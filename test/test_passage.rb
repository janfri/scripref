# - encoding: utf-8 -
require 'test_helper'

class TestPassage < Test::Unit::TestCase

  include Scripref

  def setup
    @parser = Parser.new(German)
  end

  def test_to_a
    pass = @parser.parse('Mr 1,2-Luk 3,4').first
    assert_equal [41, 1, 2, 42, 3, 4], pass.to_a
  end

  def test_spaceship_operator
    ast = @parser.parse('Mar 2,3; Joh 1,5')
    p1, p2 = ast[0], ast[2]
    assert_nil p1 <=> :other_value
    assert_nil :other_value <=> p1
    assert_equal (-1), p1 <=> p2
    assert_equal 0, p1 <=> p1
    assert_equal 1, p2 <=> p1
  end

  def test_comparable_with_sort
    ast = @parser.parse('Joh 8,1-9,11; 8,2-9,12; 8,2-9,11; 8,1-9,12; Joh 8')
    passages = ast.grep(Passage)
    expect = ['Joh 8',
              'Joh 8,1-9,11',
              '8,1-9,12',
              '8,2-9,11',
              '8,2-9,12']
    assert_equal expect, passages.sort.map(&:text)

    ast = @parser.parse('Mar 1; 1,1; 1,1f; 1,1ff; 1,2; 1,1-2,2; Mar 1-2; Markus; Markus-Lukas; Mar 1-Luk 2; Mar 1,1-Luk 2,2')
    passages = ast.grep(Passage)
    formatter = Formatter.new(German)
    expect = ['Markus 1,1',
              'Markus 1,1f',
              'Markus 1,1ff',
              'Markus 1',
              'Markus 1,1-2,2',
              'Markus 1-2',
              'Markus',
              'Markus 1,1-Lukas 2,2',
              'Markus 1-Lukas 2',
              'Markus-Lukas',
              'Markus 1,2']
    assert_equal expect, passages.sort.map {|e| formatter << e}
  end

  def test_overlap
    a = @parser.parse('Joh 8,1-9').first
    b = @parser.parse('Joh 8,8-11').first
    c = @parser.parse('Joh 8,12-15').first
    d = @parser.parse('Joh 8,15-18').first
    e = @parser.parse('Joh 8').first
    assert_overlap a, a
    assert_overlap a, b
    assert_not_overlap b, c
    assert_overlap c, d
    assert_overlap d, e
  end

  def test_start
    p = Passage.new('', 1, 2, 3, 4, 5, 6)
    assert_equal [1, 2, 3], p.start
  end

  def test_end
    p = Passage.new('', 1, 2, 3, 4, 5, 6)
    assert_equal [4, 5, 6], p.end
  end

  protected

  def assert_overlap a, b
    assert a.overlap?(b)
    assert b.overlap?(a)
  end

  def assert_not_overlap a, b
    assert !a.overlap?(b)
    assert !b.overlap?(a)
  end
end
