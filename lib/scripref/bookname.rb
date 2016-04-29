# - encoding: utf-8 -

module Scripref

  class Bookname

    attr_reader :names, :abbrevs

    def initialize names, abbrevs
      @names = Array(names)
      @abbrevs = Array(abbrevs)
    end

    def name
      @names.first
    end

    def abbrev level=0
      @abbrevs[level] || @abbrevs[-1]
    end

    def to_s
      @names.first
    end

    alias to_str to_s

  end

end
