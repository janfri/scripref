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
      b1 #or nil handle_fail
    end

    # 1st book scanned
    def b1
      s = scan(book_re) or return nil
      @text << s
      @b1 = @b2 = book2num(s)
      @c1 = @v1 = 1
      @c2 = @v2 = :max

      epsilon or c1 or nil
    end

    def c1
      s = scan(/\d+\s*/) or return nil
      @text << s
      @c1 = @c2 = s.to_i

      epsilon or nil
    end

    def epsilon
      if eos?
        @result << Passage.new(@text, @b1, @c1, @v1, @b2, @c2, @v2)
        @text = ''
        return @result
      end
      nil
    end

    def handle_fail
      raise 'failure'
    end

  end

end
