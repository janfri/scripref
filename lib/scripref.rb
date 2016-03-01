# - encoding: utf-8 -
require 'delegate'
require 'scripref/parser'
require 'scripref/processor'
require 'scripref/formatter'
require 'scripref/english'
require 'scripref/german'

module Scripref

  VERSION = '0.9.1'

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

    def make_comparable max: 999, ff: 3
      self.dup.make_comparable! max: max, ff: ff
    end

    def make_comparable! max: 999, ff: 3
      self.b1 ||= 0
      self.c1 ||= 0
      self.v1 ||= 0
      self.b2 ||= max
      self.c2 ||= max
      self.v2 ||= max
      if self.v2 == :ff
        self.v2 = self.v1 + ff
      end
      self
    end

    def comparable?
      to_a.map {|e| Numeric === e}.uniq == [true]
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

end
