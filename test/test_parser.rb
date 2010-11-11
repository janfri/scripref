# - encoding: utf-8 -
require 'test_helper'

class TestParser < Test::Unit::TestCase

  def setup
    @parser = Scripref::Parser.new(Scripref::German)
  end

  def test_only_book
    text = 'Ruth'
    res = @parser.parse(text)
    assert_equal 1, res.size
    assert_equal_passage Scripref::Passage.new(text, 8, 1, 1, 8, :max, :max), res.first
  end

end
