# - encoding: utf-8 -
require 'test_helper'

class TestParser < Test::Unit::TestCase

  include Test::Helper

  def setup
    @parser = Scripref::Parser.new(Scripref::German)
  end

  def test_only_book
    text = 'Ruth'
    res = @parser.parse(text)
    assert_array_size res, 1
    assert_equal_passage Scripref::Passage.new(text, 8, 1, 1, 8, :max, :max), res.first
  end

  def test_book_and_chapter
    text = 'Ruth 2'
    res = @parser.parse(text)
    assert_array_size res, 1
    assert_equal_passage Scripref::Passage.new(text, 8, 2, 1, 8, 2, :max), res.first
  end

  def test_book_chapter_and_verse
    text = 'Ruth 2,5'
    res = @parser.parse(text)
    assert_array_size res, 1
    assert_equal_passage Scripref::Passage.new(text, 8, 2, 5, 8, 2, 5), res.first
  end

  def test_verse_range
    text = 'Ruth 2,5-11'
    res = @parser.parse(text)
    assert_array_size res, 1
    assert_equal_passage Scripref::Passage.new(text, 8, 2, 5, 8, 2, 11), res.first
  end

  def test_chapter_verse_range
    text = 'Ruth 2,5-3,7'
    res = @parser.parse(text)
    assert_array_size res, 1
    assert_equal_passage Scripref::Passage.new(text, 8, 2, 5, 8, 3, 7), res.first
  end

  def test_chapter_range
    text = 'Ruth 2-3'
    res = @parser.parse(text)
    assert_array_size res, 1
    assert_equal_passage Scripref::Passage.new(text, 8, 2, 1, 8, 3, :max), res.first
  end

end
