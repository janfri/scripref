# - encoding: utf-8 -
require 'strscan'

module Scripref
  
  class Parser < StringScanner

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
      if s = scan(book_re)
        b1(s)
      else
        # fail
      end
    end

    # 1st book scanned
    def b1 s
      @text << s
      @b1 = @b2 = book2num(s)
      @c1 = @v1 = 1
      @c2 = @v2 = :max
      #
      if eos?
        @result << Passage.new(@text, @b1, @c1, @v1, @b2, @c2, @v2)
        return @result
      end
    end

  end

end
