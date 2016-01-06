# - encoding: utf-8 -
require 'delegate'
require 'scripref/parser'
require 'scripref/processor'
require 'scripref/formatter'
require 'scripref/english'
require 'scripref/german'

module Scripref

  VERSION = '0.7.1'

  Passage = Struct.new(:text, :b1, :c1, :v1, :b2, :c2, :v2, :a1, :a2) do

    include Comparable

    def initialize text, b1, c1, v1, b2, c2, v2, opts={}
      super text, b1, c1, v1, b2, c2, v2, opts[:a1], opts[:a2]
    end

    def to_a
      [b1, c1, v1, b2, c2, v2]
    end

    def <=> o
      a1 = self.to_a.map {|e| e.nil? ? 0 : e}
      a2 = o.to_a.map {|e| e.nil? ? 0 : e}
      a1 <=> a2
    end

    alias to_s text
  end

  class Sep < DelegateClass(String)
    def initialize s
      super s
    end
  end
  class PassSep < Sep; end
  class VerseSep < Sep; end

  # check if the book has only one chapter
  def self.book_has_only_one_chapter? book
    [31, 63, 64, 65].include?(book)
  end

end
