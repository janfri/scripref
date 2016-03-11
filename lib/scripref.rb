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

    def <=> other
      return unless other.kind_of? Passage
      self.make_comparable.to_a <=> other.make_comparable.to_a
    end

    # Returns a copy which is comparable, that means
    # all values are numeric.
    # This is a heuristic approach.
    def make_comparable max: 999, ff: 3
      self.dup.make_comparable! max: max, ff: ff
    end

    # Makes the Passage instance comparable, that means
    # all values are numeric.
    # This is a heuristic approach.
    def make_comparable! max: 999, ff: 3
      self.b1 ||= 1
      self.c1 ||= 1
      self.v1 ||= 1
      self.b2 ||= max
      self.c2 ||= max
      self.v2 ||= max
      if self.v2 == :f
        self.v2 = self.v1 + 1
      end
      if self.v2 == :ff
        self.v2 = self.v1 + ff
      end
      self
    end

    # Checks if the instance is comparable, that means
    # all values are numeric and so the <=> method
    # can be applied.
    def comparable?
      to_a.map {|e| Numeric === e}.uniq == [true]
    end

    # Returns true if the instance and the given passage overlap.
    # That means both has at least one verse in common.
    def overlap? passage
      fail ArgumentError, 'value must be a passage' unless passage.kind_of? Passage
      a = self.make_comparable.to_a
      b = passage.make_comparable.to_a
      [a[0..2] <=> b[3..5], b[0..2] <=> a[3..5]].max < 1
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
