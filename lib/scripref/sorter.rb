# encoding: utf-8
# frozen_string_literal: true

module Scripref

  class Sorter

    def initialize *mods
      @mods = mods
      mods.each {|m| extend m}
    end

    def sort *references
      passages = references.flatten.select {|e| e.kind_of? Scripref::Passage}
      passages.sort do |p1, p2|
        signum(p1, p2)
      end
    end

    alias << sort

    # Mixin to sort ascending by start verse and desending by end verse of passages
    module SortUpDown
      def signum pass1, pass2
        a, b = passage2arr(pass1), passage2arr(pass2)
        a[0, 3] + b[3, 3] <=> b[0, 3] + a[3, 3]
      end
    end

    # Mixin to sort ascending by start verse and ascending by end verse of passages
    module SortUpUp
      def signum pass1, pass2
        a, b = passage2arr(pass1), passage2arr(pass2)
        a <=> b
      end
    end

    # Default sorting

    include SortUpDown

    private

    def passage2arr pass
      b1 = book2num(pass.b1)
      b2 = book2num(pass.b2)
      [b1, pass.c1 || 1, pass.v1 || 1, b2, pass.c2 || Float::INFINITY, pass.v2 || Float::INFINITY]
    end

  end

end
