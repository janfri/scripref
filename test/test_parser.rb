# - encoding: utf-8 -
require 'test_helper'

class TestParser < Test::Unit::TestCase

  include Test::Helper

  def setup
    @parser = Scripref::Parser.new(Scripref::German)
  end

  def test_only_book
    text = 'Ruth'
    assert_parsed_passage Scripref::Passage.new(text, 8, 1, 1, 8, :max, :max), text
  end

  def test_book_and_chapter
    text ='Ruth 2'
    assert_parsed_passage Scripref::Passage.new(text, 8, 2, 1, 8, 2, :max), text
  end

  def test_book_chapter_and_verse
    text ='Ruth 2,5'
    assert_parsed_passage Scripref::Passage.new(text, 8, 2, 5, 8, 2, 5), text
  end

  def test_verse_range
    text ='Ruth 2,5-11'
    assert_parsed_passage Scripref::Passage.new(text, 8, 2, 5, 8, 2, 11), text
  end

  def test_chapter_verse_range
    text ='Ruth 2,5-3,7'
    assert_parsed_passage Scripref::Passage.new(text, 8, 2, 5, 8, 3, 7), text
  end

  def test_chapter_range
    text ='Ruth 2-3'
    assert_parsed_passage Scripref::Passage.new(text, 8, 2, 1, 8, 3, :max), text
  end

end
