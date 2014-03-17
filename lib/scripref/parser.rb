# - encoding: utf-8 -
require 'strscan'

module Scripref

  class Parser < StringScanner

    NUMBER_RE = /\d+\s*/

    # @param mods on ore more modules to include
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
      @b1 = @b2 = book2num(s)
      @c1 = @v1 = nil
      @c2 = @v2 = nil

      epsilon or c1 or nil
    end

    # try parse first chapter
    def c1
      s = scan(NUMBER_RE) or return nil
      @text << s
      @c1 = @c2 = s.to_i

      if cv_sep
        v1 or nil
      elsif hyphen
        c2 or nil
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
        if check(Regexp.new(NUMBER_RE.source + cv_sep_re.source))
          c2
        else
          v2 or nil
        end
      elsif pass_sep
        b1 or c1
      elsif verse_sep
        v1
      else
        epsilon or nil
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
      @result << Passage.new(@text, @b1, @c1, @v1, @b2, @c2, @v2, a1: @a1)
      @text = ''
    end

    def book2num str
      return nil unless book_re =~str
      books_res.each_with_index do |re, i|
       if str =~ Regexp.new('^' << re.to_s << '$')
         num = i + 1
         return num
       end
      end
    end

    def inspect
      "#<#{self.class} #{@mods.inspect}>"
    end

  end

end
