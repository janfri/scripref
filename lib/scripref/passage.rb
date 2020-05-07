# encoding: utf-8
# frozen_string_literal: true

module Scripref

  Passage = Struct.new(:text, :b1, :c1, :v1, :b2, :c2, :v2, :a1, :a2, keyword_init: true) do

    include Comparable

    def to_a
      [b1, c1, v1, b2, c2, v2]
    end

    def <=> other
      return unless other.kind_of? Passage
      self.to_numeric_array <=> other.to_numeric_array
    end

    # Returns true if the instance and the given passage overlap.
    # That means both has at least one verse in common.
    def overlap? passage
      fail ArgumentError, 'value must be a passage' unless passage.kind_of? Passage
      a = self.to_numeric_array
      b = passage.to_numeric_array
      [a[0..2] <=> b[3..5], b[0..2] <=> a[3..5]].max < 1
    end

    # Returns an array of b1, c1, v1
    def start
      [b1, c1, v1]
    end

    # Returns an array of b2, c2, v2
    def end
      [b2, c2, v2]
    end

    def to_numeric_array max: 999, ff: 3
      _b1 = Passage.book_id2num[b1]
      _c1 = c1 || 1
      _v1 = v1 || 1
      _b2 = Passage.book_id2num[b2]
      _c2 = c2 || max
      _v2 = v2 || max
      if _v2 == :f
        _v2 = _v1 + 1
      end
      if _v2 == :ff
        _v2 = _v1 + ff
      end
      [_b1, _c1, _v1, _b2, _c2, _v2]
    end

    alias to_s text

    @book_id2num = {}
    osis_book_ids = %i[
      Gen Exod Lev Num Deut Josh Judg Ruth 1Sam 2Sam 1Kgs 2Kgs 1Chr 2Chr Ezra
      Neh Esth Job Ps Prov Eccl Song Isa Jer Lam Ezek Dan Hos Joel Amos Obad
      Jonah Mic Nah Hab Zeph Hag Zech Mal Matt Mark Luke John Acts Rom 1Cor
      2Cor Gal Eph Phil Col 1Thess 2Thess 1Tim 2Tim Titus Phlm Heb Jas 1Pet
      2Pet 1John 2John 3John Jude Rev
    ]
    osis_book_ids.each_with_index do |book_id, i|
      @book_id2num[book_id] = i+1
    end

    class << self
      attr_reader :book_id2num
    end

  end

end
