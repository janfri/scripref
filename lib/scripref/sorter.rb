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
        a[0, 4] + b[4, 4] <=> b[0, 4] + a[4, 4]
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
      c1 = pass.c1 || 1
      v1 = pass.v1 || 1
      a1 = case pass.a1.to_s
           when ''
             0
           when 'a'
             1
           when 'b'
             2
           when 'c'
             3
           end
      b2 = book2num(pass.b2)
      c2 = pass.c2 || Float::INFINITY
      v2 = case pass.v2
           when nil
             Float::INFINITY
           when Integer
             pass.v2
           when :f
             pass.v1.to_i + 1
           when :ff
             pass.v1.to_i + 3
           end
      a2 = case pass.a2.to_s
           when ''
             0
           when 'a'
             -3
           when 'b'
             -2
           when 'c'
             -1
           end
      [b1, c1, v1, a1, b2, c2, v2, a2]
    end

  end

end
