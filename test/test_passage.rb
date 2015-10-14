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

  def test_ordering
    ast = @parser.parse('Joh 8,1-9,11; 8,2-9,12; 8,2-9,11; 8,1-9,12; Joh 8')
    passages = ast.select {|e| Scripref::Passage === e}
    assert_equal ["Joh 8", "Joh 8,1-9,11", "8,1-9,12", "8,2-9,11", "8,2-9,12"], passages.sort.map(&:text)
  end

end
