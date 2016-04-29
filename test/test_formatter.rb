# - encoding: utf-8 -
require 'test_helper'

class TestFormatter < Test::Unit::TestCase

  include Scripref
  include Test::Helper

  def setup
    @german_formatter = Formatter.new(German)
    @english_formatter = Formatter.new(English)
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

  ######################################################################
  # more than one passage
  ######################################################################

  def test_two_books
    text = 'Ruth; Markus'
    t1, t2 = text.split(semi)
    assert_formated_text_for_ast text, [pass(t1, 8, nil, nil, 8, nil, nil), semi, pass(t2, 41, nil, nil, 41, nil, nil)]
  end

  def test_two_complete_refs
    text = 'Ruth 2,1; Markus 4,8'
    t1, t2 = text.split(semi)
    assert_formated_text_for_ast text, [pass(t1, 8, 2, 1, 8, 2, 1), semi, pass(t2, 41, 4, 8, 41, 4, 8)]
  end

  def test_two_refs_same_book
    text = 'Ruth 2,1; 5,4'
    t1, t2 = text.split(semi)
    assert_formated_text_for_ast text, [pass(t1, 8, 2, 1, 8, 2, 1), semi, pass(t2, 8, 5, 4, 8, 5, 4)]
  end

  def test_two_chapters_same_book
    text = 'Ruth 2; 5'
    t1, t2 = text.split(semi)
    assert_formated_text_for_ast text, [pass(t1, 8, 2, nil, 8, 2, nil), semi, pass(t2, 8, 5, nil, 8, 5, nil)]
  end

  def test_two_chapters_different_book
    text = 'Ruth 2; Markus 4'
    t1, t2 = text.split(semi)
    assert_formated_text_for_ast text, [pass(t1, 8, 2, nil, 8, 2, nil), semi, pass(t2, 41, 4, nil, 41, 4, nil)]
  end

  def test_two_verses
    text = 'Ruth 2,5.11'
    t1, t2 = text.split(dot)
    assert_formated_text_for_ast text, [pass(t1, 8, 2, 5, 8, 2, 5), dot, pass(t2, 8, 2, 11, 8, 2, 11)]
  end

  def test_partial_passage_after_full_passage
    text = 'Ruth 2,5; 4'
    t1, t2 = text.split(semi)
    assert_formated_text_for_ast text, [pass(t1, 8, 2, 5, 8, 2, 5), semi, pass(t2, 8, 4, nil, 8, 4, nil)]
    text = 'Ruth 2,5; Markus'
    t1, t2 = text.split(semi)
    assert_formated_text_for_ast text, [pass(t1, 8, 2, 5, 8, 2, 5), semi, pass(t2, 41, nil, nil, 41, nil, nil)]
    text = 'Ruth 2,5; Markus 4'
    t1, t2 = text.split(semi)
    assert_formated_text_for_ast text, [pass(t1, 8, 2, 5, 8, 2, 5), semi, pass(t2, 41, 4, nil, 41, 4, nil)]
  end

  ######################################################################
  # mixed variants of more than one passage
  ######################################################################

  def test_verse_range_and_separated_verse
    text = 'Ruth 2,1-3.11'
    t1, t2 = text.split(dot)
    assert_formated_text_for_ast text, [pass(t1, 8, 2, 1, 8, 2, 3), dot, pass(t2, 8, 2, 11, 8, 2, 11)]
  end

  def test_separate_verse_and_verse_range
    text = 'Ruth 2,1.3-11'
    t1, t2 = text.split(dot)
    assert_formated_text_for_ast text, [pass(t1, 8, 2, 1, 8, 2, 1), dot, pass(t2, 8, 2, 3, 8, 2, 11)]
  end

  def test_two_verse_ranges
    text = 'Ruth 2,1-3.7-11'
    t1, t2 = text.split(dot)
    assert_formated_text_for_ast text, [pass(t1, 8, 2, 1, 8, 2, 3), dot, pass(t2, 8, 2, 7, 8, 2, 11)]
  end

  def test_two_verse_range_different_books
    text = 'Ruth 2,1-11; Markus 4,3-7'
    t1, t2 = text.split(semi)
    assert_formated_text_for_ast text, [pass(t1, 8, 2, 1, 8, 2, 11), semi, pass(t2, 41, 4, 3,41, 4, 7)]
  end

  def test_two_verse_range_different_chapters
    text = 'Ruth 2,1-11; 3,10-19'
    t1, t2 = text.split(semi)
    assert_formated_text_for_ast text, [pass(t1, 8, 2, 1, 8, 2, 11), semi, pass(t2, 8, 3, 10, 8, 3, 19)]
  end

  def test_book_range_and_following_book
    text = 'Ruth-Markus; Johannes'
    t1, t2 = text.split(semi)
    assert_formated_text_for_ast text, [pass(t1, 8, nil, nil, 41, nil, nil), semi, pass(t2, 43, nil, nil, 43, nil, nil)]
  end

  def test_chapter_range_and_following_book
    text = 'Ruth 1-2; Johannes 4'
    t1, t2 = text.split(semi)
    assert_formated_text_for_ast text, [pass(t1, 8, 1, nil, 8, 2, nil), semi, pass(t2, 43, 4, nil, 43, 4, nil)]
  end

  def test_chapter_range_and_following_chapter
    text = 'Ruth 1-2; 4'
    t1, t2 = text.split(semi)
    assert_formated_text_for_ast text, [pass(t1, 8, 1, nil, 8, 2, nil), semi, pass(t2, 8, 4, nil, 8, 4, nil)]
  end

  def test_book_only_after_full_passage
    text = 'Matthäus 3,4; Markus; Johannes 3,16'
    t1, t2, t3 = text.split(semi)
    assert_formated_text_for_ast text, [pass(t1, 40, 3, 4, 40, 3, 4), semi, pass(t2, 41, nil, nil, 41, nil, nil), semi, pass(t3, 43, 3, 16, 43, 3, 16)]
  end

  def test_chapter_only_after_full_passage
    text = 'Matthäus 3,4; 8; Johannes 3,16'
    t1, t2, t3 = text.split(semi)
    assert_formated_text_for_ast text, [pass(t1, 40, 3, 4, 40, 3, 4), semi, pass(t2, 40, 8, nil, 40, 8, nil), semi, pass(t3, 43, 3, 16, 43, 3, 16)]
  end

  ######################################################################
  # complex variants of references
  ######################################################################

  def test_complex_example
    text = 'Ruth 2,1-11.15; 3,7.9-12; Markus 4; 5,3.18-21'
    t1, t2, t3, t4, t5, t6, t7 = text.split(/; |\./)
    ast = [
      pass(t1, 8, 2, 1, 8, 2, 11), dot,
      pass(t2, 8, 2, 15, 8, 2, 15), semi,
      pass(t3, 8, 3, 7, 8, 3, 7), dot,
      pass(t4, 8, 3, 9, 8, 3, 12), semi,
      pass(t5, 41, 4, nil, 41, 4, nil), semi,
      pass(t6, 41, 5, 3, 41, 5, 3), dot,
      pass(t7, 41, 5, 18, 41, 5, 21)
    ]
    assert_formated_text_for_ast text, ast
  end

  ######################################################################
  # Formatting of books
  ######################################################################

  def test_formatting_with_book_abbrevs
    @german_formatter.bookformat = :abbrev
    text = 'Mat 3,4; Mar; Joh 3,16'
    t1, t2, t3 = text.split(semi)
    assert_formated_text_for_ast text, [pass(t1, 40, 3, 4, 40, 3, 4), semi, pass(t2, 41, nil, nil, 41, nil, nil), semi, pass(t3, 43, 3, 16, 43, 3, 16)]
  end

  def test_exception_for_unhandled_bookformat
    assert_raise NoMethodError do
      @german_formatter.bookformat = :unknown
      @german_formatter.format [pass(1,2,3,4,5,6,7)]
    end
  end
  private

  def assert_formated_text_for_ast text, ast
    assert_equal text, @german_formatter.format(ast)
  end

end
