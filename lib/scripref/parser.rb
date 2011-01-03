# - encoding: utf-8 -
require 'strscan'

module Scripref
  
  class Parser < StringScanner

    NUMBER_RE = /\d+\s*/

    def initialize mod
      extend mod
    end

    def parse str
      self.string = str
      @result = []
      start
    end

    def start
      @text = ''
      b1 or []
    end

    # try to parse first book
    def b1
      s = scan(book_re) or return nil
      @text << s
      @b1 = @b2 = book2num(s)
      @c1 = @v1 = 1
      @c2 = @v2 = :max

      epsilon or c1 or nil
    end

    # try parse first chapter
    def c1
      s = scan(NUMBER_RE) or return nil
      @text << s
      @c1 = @c2 = s.to_i

      if s = scan(cv_sep_re)
        @text << s
        v1 or nil
      elsif s = scan(hyphen_re)
        @text << s
        c2 or nil
      elsif s = scan(ref_sep_re)
        push_passage
        @result << s
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

      if s = scan(hyphen_re)
        @text << s
        if check(Regexp.new(NUMBER_RE.source + cv_sep_re.source))
          c2
        else
          v2 or nil
        end
      elsif s = scan(ref_sep_re)
        push_passage
        @result << s
        b1 or c1
      else
        epsilon or nil
      end
    end

    # try to parse second chapter
    def c2
      s = scan(NUMBER_RE) or return nil
      @text << s
      @c2 = s.to_i

      if s = scan(cv_sep_re)
        @text << s
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

      epsilon or nil
    end

    def epsilon
      if eos?
        push_passage
        return @result
      end
      nil
    end

    def push_passage
      @result << Passage.new(@text, @b1, @c1, @v1, @b2, @c2, @v2)
      @text = ''
    end

    def handle_fail
      raise 'failure'
    end

  end

end
