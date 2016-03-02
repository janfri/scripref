# - encoding: utf-8 -
require 'strscan'

module Scripref

  class Parser < StringScanner

    attr_reader :error

    NUMBER_RE = /\d+\s*/o

    # @param mods one or more modules to include
    def initialize *mods
      @mods = mods
      mods.each {|m| extend m}
    end

    # Regular expression to match a chapter
    def chapter_re
      NUMBER_RE
    end

    # Regular expression to match a verse
    def verse_re
      NUMBER_RE
    end

    # Hash with special abbreviations
    # for example {'Phil' => 'Philipper'}
    # usual overwritten in Mixins
    def special_abbrev_mapping
      @special_abbrev_mapping ||= {}
    end

    # Parsing a string of a scripture reference
    # @param str string to parse
    def parse str
      self.string = str
      @result = []
      @error = nil
      start
    end

    # start of parsing grammer
    def start
      @text = ''
      b1 or give_up 'Book expected!'
    end

    # try to parse first book
    def b1
      s = scan(book_re) or return nil
      @text << s
      @b1 = @b2 = abbrev2num(s)

      if pass_sep
        b1 or give_up 'EOS or book expected!'
      elsif check(Regexp.new(chapter_re.source + cv_sep_re.source))
        @c1 = @v1 = nil
        @c2 = @v2 = nil
        c1
      else
        if book_has_only_one_chapter?(@b1)
          @c1 = @c2 = 1
          epsilon or (hyphen and b2) or v1 or give_up 'EOS or hyphen and book or verse expected!'
        else
          @c1 = @v1 = nil
          @c2 = @v2 = nil
          epsilon or (hyphen and b2) or c1 or give_up 'EOS or hyphen and book or chapter expected!'
        end
      end
    end

    # try parse first chapter
    def c1
      s = scan(chapter_re) or return nil
      @text << s
      @c1 = @c2 = s.to_i

      if cv_sep
        v1 or give_up 'Verse expected!'
      elsif hyphen
        b2 or c2 or give_up 'Book or chapter expected!'
      elsif pass_sep
        b1 or c1 or give_up 'Book or chapter expected!'
      else
        epsilon or give_up 'EOS or chapter verse separator or hyphen and book or hyphen and chapter or passage separator and book or passage separator and chapter expected!'
      end
    end

    # try to parse first verse
    def v1
      s = scan(verse_re) or return nil
      @text << s
      @v1 = @v2 = s.to_i

      if addon = verse_addon
        @a1 = addon
      end

      if postfix = verse_postfix
        @v2 = postfix
      end

      if hyphen
        b2 or (
        if check(Regexp.new(chapter_re.source + cv_sep_re.source))
          c2
        else
          v2 or give_up 'Chapter or verse expected!'
        end)
      elsif pass_sep
        b1 or c1 or give_up 'Book or chapter expected!'
      elsif verse_sep
        v1 or give_up 'Verse expected!'
      else
        epsilon or give_up 'EOS or passage separator or verse separator or hyphen expected!'
      end
    end

    # try to parse second book
    def b2
      s = scan(book_re) or return nil
      @text << s
      @b2 = abbrev2num(s)
      @c2 = @v2 = nil

      if pass_sep
        b1 or give_up 'EOS or book expected!'
      elsif check(Regexp.new(chapter_re.source + cv_sep_re.source))
        c2
      else
        if book_has_only_one_chapter?(@b2)
          @c2 = 1
          epsilon or v2 or give_up 'EOS or chapter or verse expected!'
        else
          epsilon or c2 or give_up 'EOS or chapter expected!'
        end
      end
    end

    # try to parse second chapter
    def c2
      s = scan(chapter_re) or return nil
      @text << s
      @c2 = s.to_i

      if cv_sep
        v2 or give_up 'Verse expected!'
      elsif pass_sep
        b1 or c1 or give_up 'Book or chapter expected!'
      else
        epsilon or give_up 'EOS or chapter verse separator expected!'
      end
    end

    # try to parse second verse
    def v2
      s = scan(verse_re) or return nil
      @text << s
      @v2 = s.to_i

      if addon = verse_addon
        @a2 = addon
      end

      if verse_sep
        v1 or give_up 'Verse expected!'
      elsif pass_sep
        b1 or c1 or give_up 'Book or chapter expected!'
      else
        epsilon or give_up 'EOS or verse separator or passage separator expected!'
      end
    end

    # try to parse <tt>end of string</tt>
    def epsilon
      if eos?
        push_passage
        return @result
      end
      nil
    end

    # try to parse separator or chapter and verse
    def cv_sep
      if s = scan(cv_sep_re)
        @text << s
        s
      else
        nil
      end
    end

    # try to parse hyphen
    def hyphen
      if s = scan(hyphen_re)
        @text << s
        s
      else
        nil
      end
    end

    # try to parse separator between passages
    def pass_sep
      if s = scan(pass_sep_re)
        push_passage
        @result << PassSep.new(s)
        s
      else
        nil
      end
    end

    # try to parse verse separator
    def verse_sep
      if s = scan(verse_sep_re)
        push_passage
        @result << VerseSep.new(s)
        s
      else
        nil
      end
    end

    # try to parse addons for verses
    def verse_addon
      if s = scan(verse_addon_re)
        @text << s
        s.to_sym
      else
        nil
      end
    end

    # try to parse postfixes for verse
    def verse_postfix
      s = (scan(postfix_one_following_verse_re) or scan(postfix_more_following_verses_re))
      if s
        @text << s
        s.to_sym
      else
        nil
      end
    end

    def push_passage
      @result << Passage.new(@text, @b1, @c1, @v1, @b2, @c2, @v2, a1: @a1, a2: @a2)
      @text = ''
      @a1 = @a2 = nil
    end

    # Regular expression to match a book.
    def book_re
      return @book_re if @book_re
      books_res_as_strings = book_names.flatten.map do |bn|
        (bn.gsub(/([^\dA-Z])/, '\1?').gsub('.', '\.')) << '\b\s*'
      end
      @book_re = Regexp.compile(books_res_as_strings.map {|s| '(^' << s << ')' }.join('|'), nil)
    end

    def abbrev2num str
      book2num(abbrev2book(str))
    end

    def abbrev2book str
      s = str.strip
      if name = special_abbrev_mapping[s]
        return name
      end
      @books_str ||= ('#' << book_names.flatten.join('#') << '#')
      pattern = s.chars.map {|c| Regexp.escape(c) << '[^#]*'}.join
      re = /(?<=#)#{pattern}(?=#)/
      names = @books_str.scan(re)
      if names.size != 1
        unscan
        give_up format("Abbreviation %s is ambiguous it matches %s!", s, names.join(', '))
      end
      names.first
    end

    def book2num str
      unless @book2num
        @book2num = {}
        book_names.each_with_index do |bns, i|
          Array(bns).each do |bn|
            @book2num[bn] = i+1
          end
        end
      end
      @book2num[str]
    end

    def inspect
      "#<#{self.class} #{@mods.inspect}>"
    end

    def give_up msg
      @error = msg
      fail ParserError, format_error
    end

    def format_error
      if error
        format("%s\n%s\n%s^", error, string, ' ' * pointer)
      else
        ''
      end
    end

    alias << parse

  end

  class ParserError < RuntimeError; end

end
