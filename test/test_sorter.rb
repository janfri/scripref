# encoding: utf-8
# frozen_string_literal: true

require_relative 'test_helper'

class TestSorter < Test::Unit::TestCase

  include Scripref
  include Test::Helper

  def setup
    @john_1 = pass(b1: :John, c1: 1, b2: :John, c2: 1)
    @john_1_1_3 = pass(b1: :John, c1: 1, v1: 1, b2: :John, c2: 1, v2: 3)
    @john_1_1_18 = pass(b1: :John, c1: 1, v1: 1, b2: :John, c2: 1, v2: 18)
    @john_2 = pass(b1: :John, c1: 2, b2: :John, c2: 2)
    @heb_9 = pass(b1: :Heb, c1: 9, b2: :Heb, c2: 9)
    @jas_1 = pass(b1: :Jas, c1: 1, b2: :Jas, c2: 1)
    @pet_1 = pass(b1: :'1Pet', c1: 1, b2: :'1Pet', c2: 1)
  end

  def test_canonical_default
    sorter = Sorter.new(Bookorder::Canonical)
    assert_equal [@john_1, @heb_9, @jas_1, @pet_1], sorter.sort([@heb_9, @pet_1, @jas_1, @john_1])
    assert_equal [@john_1_1_18, @john_1_1_3], sorter.sort([@john_1_1_3, @john_1_1_18])
    assert_equal [@john_1, @john_1_1_18, @john_1_1_3, @john_2], sorter.sort([@john_1, @john_1_1_3, @john_2, @john_1_1_18])
  end

  def test_canonical_sort_up_up
    sorter = Sorter.new(Bookorder::Canonical, Sorter::SortUpUp)
    assert_equal [@john_1_1_3, @john_1_1_18], sorter.sort([@john_1_1_3, @john_1_1_18])
    assert_equal [@john_1_1_3, @john_1_1_18, @john_1, @john_2], sorter.sort([@john_1, @john_1_1_3, @john_2, @john_1_1_18])
  end

  def test_luther_default
    sorter = Sorter.new(Bookorder::Luther)
    assert_equal [@john_1, @pet_1, @heb_9, @jas_1], sorter.sort([@heb_9, @pet_1, @jas_1, @john_1])
    assert_equal [@john_1_1_18, @john_1_1_3], sorter.sort([@john_1_1_3, @john_1_1_18])
    assert_equal [@john_1, @john_1_1_18, @john_1_1_3, @john_2], sorter.sort([@john_1, @john_1_1_3, @john_2, @john_1_1_18])
  end

  def test_luther_sort_up_up
    sorter = Sorter.new(Bookorder::Luther, Sorter::SortUpUp)
    assert_equal [@john_1, @pet_1, @heb_9, @jas_1], sorter.sort([@heb_9, @pet_1, @jas_1, @john_1])
    assert_equal [@john_1_1_3, @john_1_1_18], sorter.sort([@john_1_1_3, @john_1_1_18])
    assert_equal [@john_1_1_3, @john_1_1_18, @john_1, @john_2], sorter.sort([@john_1, @john_1_1_3, @john_2, @john_1_1_18])
  end

end
