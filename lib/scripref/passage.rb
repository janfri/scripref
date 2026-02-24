# encoding: utf-8
# frozen_string_literal: true

module Scripref

  Passage = Struct.new(:text, :b1, :c1, :v1, :b2, :c2, :v2, :a1, :a2, keyword_init: true) do

    def to_a
      [b1, c1, v1, b2, c2, v2]
    end

    def == other
      return false unless other.kind_of? Passage
      to_a == other.to_a
    end

    alias to_s text

  end

end
