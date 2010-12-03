# - encoding: utf-8 -
require 'test_helper'

class TestParser < Test::Unit::TestCase

  include Test::Passage

  def setup
    @parser = Scripref::Parser.new(Scripref::German)
  end

  def test_only_book
    text = 'Ruth'
    res = @parser.parse(text)
    assert_equal 1, res.size
    assert_equal_passage Scripref::Passage.new(text, 8, 1, 1, 8, :max, :max), res.first
  end

  def test_book_and_chapter
    text = 'Ruth 2'
    res = @parser.parse(text)
    assert_equal 1, res.size
    assert_equal_passage Scripref::Passage.new(text, 8, 2, 1, 8, 2, :max), res.first
  end
end
