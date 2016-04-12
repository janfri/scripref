# - encoding: utf-8 -
require 'test/unit'
require 'test_helper'
require 'scripref'
require 'scripref/english'
require 'scripref/formatter'
require 'scripref/german'
require 'scripref/parser'

class TestFormatter < Test::Unit::TestCase

  include Test::Helper

  def setup
    @parser = Scripref::Parser.new(Scripref::German)
    @german_formatter = Scripref::Formatter.new(Scripref::German)
    @english_formatter = Scripref::Formatter.new(Scripref::English)
  end

  def test_only_book
    text = 'Ruth'
    assert_formated_text_for_ast text, [pass(text, 8, nil, nil, 8, nil, nil)]
  end

  def test_book_and_chapter
    text = 'Ruth 2'
    assert_formated_text_for_ast text, [pass(text, 8, 2, nil, 8, 2, nil)]
  end

  def test_book_chapter_and_verse
    text = 'Ruth 2,5'
    assert_formated_text_for_ast text, [pass(text, 8, 2, 5, 8, 2, 5)]
  end

  def test_verse_range
    text = 'Ruth 2,5-11'
    assert_formated_text_for_ast text, [pass(text, 8, 2, 5, 8, 2, 11)]
  end

  def test_chapter_verse_range
    text = 'Ruth 2,5-3,7'
    assert_formated_text_for_ast text, [pass(text, 8, 2, 5, 8, 3, 7)]
  end

  def test_chapter_range
    text = 'Ruth 2-3'
    assert_formated_text_for_ast text, [pass(text, 8, 2, nil, 8, 3, nil)]
  end

  def test_book_range
    text = '1. Mose-Offenbarung'
    assert_formated_text_for_ast text, [pass(text, 1, nil, nil, 66, nil, nil)]
  end

  def test_book_chapter_range
    text = '1. Mose 1-Offenbarung 22'
    assert_formated_text_for_ast text, [pass(text, 1, 1, nil, 66, 22, nil)]
  end

  def test_book_chapter_verse_range
    text = '1. Mose 1,1-Offenbarung 22,21'
    assert_formated_text_for_ast text, [pass(text, 1, 1, 1, 66, 22, 21)]
  end

  def test_one_following_verse
    text = 'Ruth 2,5f'
    assert_formated_text_for_ast text, [pass(text, 8, 2, 5, 8, 2, :f)]
  end

  def test_more_following_verse
    text = 'Ruth 2,5ff'
    assert_formated_text_for_ast text, [pass(text, 8, 2, 5, 8, 2, :ff)]
  end

  def test_first_addon
    text = 'Ruth 2,5a'
    assert_formated_text_for_ast text, [pass(text, 8, 2, 5, 8, 2, 5, a1: :a)]
  end

  def test_second_addon
    text = 'Ruth 2,5-7a'
    assert_formated_text_for_ast text, [pass(text, 8, 2, 5, 8, 2, 7, a2: :a)]
  end

  def test_both_addons
    text = 'Ruth 2,5b-7a'
    assert_formated_text_for_ast text, [pass(text, 8, 2, 5, 8, 2, 7, a1: :b, a2: :a)]
  end

  def test_reset_addons
    @parser.parse 'Ruth 2,5b-7a'
    text = 'Ruth'
    assert_formated_text_for_ast text, [pass(text, 8, nil, nil, 8, nil, nil)]
  end

  def test_book_with_only_one_chapter
    text = 'Obadja 3'
    assert_formated_text_for_ast text, [pass(text, 31, 1, 3, 31, 1, 3)]
    text = 'Obadja 1'
    assert_formated_text_for_ast text, [pass(text, 31, 1, 1, 31, 1, 1)]
  end

  def test_book_with_only_one_chapter_range
    text = 'Obadja 3-5'
    assert_formated_text_for_ast text, [pass(text, 31, 1, 3, 31, 1, 5)]
    text = 'Obadja 1-4'
    assert_formated_text_for_ast text, [pass(text, 31, 1, 1, 31, 1, 4)]
  end

  def test_book_with_only_one_chapter_at_begin_of_range
    omit "Doesn't work yet."
    text = 'Obadja-Jona'
    assert_formated_text_for_ast text, [pass(text, 31, 1, nil, 32, nil, nil)]
    text = 'Obadja 3-Jona 2,4'
    assert_formated_text_for_ast text, [pass(text, 31, 1, 3, 32, 2, 4)]
  end

  def test_book_with_only_one_chapter_at_end_of_range
    text = 'Amos 2,4-Obadja 3'
    assert_formated_text_for_ast text, [pass(text, 30, 2, 4, 31, 1, 3)]
    text = 'Amos 2,4-Obadja 1'
    assert_formated_text_for_ast text, [pass(text, 30, 2, 4, 31, 1, 1)]
  end

  private

  def assert_formated_text_for_ast text, ast
    assert_equal text, @german_formatter.format(ast)
  end

end
