# - encoding: utf-8 -
require 'strscan'

module Scripref

  class Parser < StringScanner

    NUMBER_RE = /\d+\s*/

    # @param mods one or more modules to include
    def initialize *mods
      @mods = mods
      mods.each do |m|
        m.class_eval do
          extend ConstReader
          const_reader constants
        end
        extend m
      end
    end

    # Parsing a string of a scripture reference
    # @param str string to parse
    def parse str
      self.string = str
      @result = []
      start
    end

    # start of parsing grammer
    def start
      @text = ''
      b1 or []
    end

    # try to parse first book
    def b1
      s = scan(book_re) or return nil
      @text << s
      @b1 = @b2 = abbrev2num(s)

      if check(Regexp.new(NUMBER_RE.source + cv_sep_re.source))
        @c1 = @v1 = nil
        @c2 = @v2 = nil
        c1
      else
        if Scripref.book_has_only_one_chapter?(@b1)
          @c1 = @c2 = 1
          epsilon or (hyphen and b2) or v1 or nil
        else
          @c1 = @v1 = nil
          @c2 = @v2 = nil
          epsilon or (hyphen and b2) or c1 or nil
        end
      end
    end

    # try parse first chapter
    def c1
      s = scan(NUMBER_RE) or return nil
      @text << s
      @c1 = @c2 = s.to_i

      if cv_sep
        v1 or nil
      elsif hyphen
        b2 or c2 or nil
      elsif pass_sep
        b1 or c1
      else
        epsilon or nil
      end
    end

    # try to parse first verse
    def v1
      s = scan(NUMBER_RE) or return nil
      @text << s
      @v1 = @v2 = s.to_i

      if addon = verse_addon
        case addon
        when :f, :ff
          @v2 = addon
        when :a, :b, :c
          @a1 = addon
        end
      end

      if hyphen
        b2 or (
        if check(Regexp.new(NUMBER_RE.source + cv_sep_re.source))
          c2
        else
          v2 or nil
        end)
      elsif pass_sep
        b1 or c1
      elsif verse_sep
        v1
      else
        epsilon or nil
      end
    end

    # try to parse second book
    def b2
      s = scan(book_re) or return nil
      @text << s
      @b2 = abbrev2num(s)
      @c2 = @v2 = nil

      if check(Regexp.new(NUMBER_RE.source + cv_sep_re.source))
        c2
      else
        if Scripref.book_has_only_one_chapter?(@b2)
          @c2 = 1
          epsilon or v2 or nil
        else
          epsilon or c2 or nil
        end
      end
    end

    # try to parse second chapter
    def c2
      s = scan(NUMBER_RE) or return nil
      @text << s
      @c2 = s.to_i

      if cv_sep
        v2 or nil
      else
        epsilon or nil
      end
    end

    # try to parse second verse
    def v2
      s = scan(NUMBER_RE) or return nil
      @text << s
      @v2 = s.to_i

      if addon = verse_addon
        case addon
        when :a, :b, :c
          @a2 = addon
        end
      end

      if verse_sep
        v1
      elsif pass_sep
        b1 or c1
      else
        epsilon or nil
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
        @result << s
        s
      else
        nil
      end
    end

    # try to parse verse separator
    def verse_sep
      if s = scan(verse_sep_re)
        push_passage
        @result << s
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

    def push_passage
      @result << Passage.new(@text, @b1, @c1, @v1, @b2, @c2, @v2, a1: @a1, a2: @a2)
      @text = ''
      @a1 = @a2 = nil
    end

    def abbrev2num str
      book2num(abbrev2book(str))
    end

    def abbrev2book str
      @books_str ||= ('#' << book_names.join('#') << '#')
      pattern = str.strip.each_char.map {|c| c << '[^#]*'}.join
      pattern.gsub!('.', '\\.')
      re = /(?<=#)#{pattern}(?=#)/
      names = @books_str.scan(re)
      fail Error, format("Abbreviation %s is ambiguous it matches %s!", str, names.join(', ')) unless names.size == 1
      names.first
    end

    def book2num str
      unless @book2num
        @book2num = {}
        book_names.each_with_index {|s, i| @book2num[s] = i+1}
      end
      @book2num[str]
    end

    def inspect
      "#<#{self.class} #{@mods.inspect}>"
    end

    alias << parse

    class Error < RuntimeError; end

  end

end
