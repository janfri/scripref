# - encoding: utf-8 -
require 'test/unit'
require 'test_helper'
require 'scripref'

class TestPassage < Test::Unit::TestCase

  def setup
    @parser = Scripref::Parser.new(Scripref::German)
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
    passages = ast.grep(Scripref::Passage)
    expect = ['Joh 8',
              'Joh 8,1-9,11',
              '8,1-9,12',
              '8,2-9,11',
              '8,2-9,12']
    assert_equal expect, passages.sort.map(&:text)

    ast = @parser.parse('Mar 1; 1,1; 1,1f; 1,1ff; 1,2; 1,1-2,2; Mar 1-2; Markus; Markus-Lukas; Mar 1-Luk 2; Mar 1,1-Luk 2,2')
    passages = ast.grep(Scripref::Passage)
    formatter = Scripref::Formatter.new(Scripref::German)
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

  def test_intersect
    a = @parser.parse('Joh 8,1-9').first
    b = @parser.parse('Joh 8,8-11').first
    c = @parser.parse('Joh 8,12-15').first
    d = @parser.parse('Joh 8,15-18').first
    e = @parser.parse('Joh 8').first
    assert_intersect a, a
    assert_intersect a, b
    assert_not_intersect b, c
    assert_intersect c, d
    assert_intersect d, e
  end

  protected

  def assert_intersect a, b
    assert a.intersect?(b)
    assert b.intersect?(a)
  end

  def assert_not_intersect a, b
    assert !a.intersect?(b)
    assert !b.intersect?(a)
  end
end
