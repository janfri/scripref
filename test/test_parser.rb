# - encoding: utf-8 -
require 'test_helper'

class TestParser < Test::Unit::TestCase

  include Scripref
  include Test::Helper

  def setup
    @parser = Parser.new(German)
  end

  def test_only_book
    text = 'Ruth'
    assert_parsed_ast_for_text [pass(text: text, b1: 8, b2: 8)], text
  end

  def test_book_abbrev
    text = 'Ru'
    assert_parsed_ast_for_text [pass(text: text, b1: 8, b2: 8)], text
    text = 'Offb'
    assert_parsed_ast_for_text [pass(text: text, b1: 66, b2: 66)], text
  end

  def test_book_abbrev_with_period
    text = 'Ru.'
    assert_parsed_ast_for_text [pass(text: text, b1: 8, b2: 8)], text
    text = 'Offb.'
    assert_parsed_ast_for_text [pass(text: text, b1: 66, b2: 66)], text
  end

  def test_ambiguous_book
    msg = 'Abbreviation Jo is ambiguous it matches Josua, Joel, Jona, Johannes, Jakobus!'
    assert_parser_error msg do
      @parser.parse 'Jo'
    end
  end

  def test_book_and_chapter
    text = 'Ruth 2'
    assert_parsed_ast_for_text [pass(text: text, b1: 8, c1: 2, b2: 8, c2: 2)], text
  end

  def test_book_chapter_and_verse
    text = 'Ruth 2,5'
    assert_parsed_ast_for_text [pass(text: text, b1: 8, c1: 2, v1: 5, b2: 8, c2: 2, v2: 5)], text
  end

  def test_verse_range
    text = 'Ruth 2,5-11'
    assert_parsed_ast_for_text [pass(text: text, b1: 8, c1: 2, v1: 5, b2: 8, c2: 2, v2: 11)], text
  end

  def test_chapter_verse_range
    text = 'Ruth 2,5-3,7'
    assert_parsed_ast_for_text [pass(text: text, b1: 8, c1: 2, v1: 5, b2: 8, c2: 3, v2: 7)], text
  end

  def test_chapter_range
    text = 'Ruth 2-3'
    assert_parsed_ast_for_text [pass(text: text, b1: 8, c1: 2, b2: 8, c2: 3)], text
  end

  def test_book_range
    text = '1. Mose - Offenbarung'
    assert_parsed_ast_for_text [pass(text: text, b1: 1, b2: 66)], text
  end

  def test_book_chapter_range
    text = '1. Mose 1 - Offenbarung 22'
    assert_parsed_ast_for_text [pass(text: text, b1: 1, c1: 1, b2: 66, c2: 22)], text
  end

  def test_book_chapter_verse_range
    text = '1. Mose 1,1-Offenbarung 22,21'
    assert_parsed_ast_for_text [pass(text: text, b1: 1, c1: 1, v1: 1, b2: 66, c2: 22, v2: 21)], text
  end

  def test_one_following_verse
    text = 'Ruth 2,5f'
    assert_parsed_ast_for_text [pass(text: text, b1: 8, c1: 2, v1: 5, b2: 8, c2: 2, v2: :f)], text
  end

  def test_more_following_verse
    text = 'Ruth 2,5ff'
    assert_parsed_ast_for_text [pass(text: text, b1: 8, c1: 2, v1: 5, b2: 8, c2: 2, v2: :ff)], text
  end

  def test_first_addon
    text = 'Ruth 2,5a'
    assert_parsed_ast_for_text [pass(text: text, b1: 8, c1: 2, v1: 5, b2: 8, c2: 2, v2: 5, a1: :a)], text
  end

  def test_second_addon
    text = 'Ruth 2,5-7a'
    assert_parsed_ast_for_text [pass(text: text, b1: 8, c1: 2, v1: 5, b2: 8, c2: 2, v2: 7, a2: :a)], text
  end

  def test_both_addons
    text = 'Ruth 2,5b-7a'
    assert_parsed_ast_for_text [pass(text: text, b1: 8, c1: 2, v1: 5, b2: 8, c2: 2, v2: 7, a1: :b, a2: :a)], text
  end

  def test_reset_addons
    @parser.parse 'Ruth 2,5b-7a'
    text = 'Ruth'
    assert_parsed_ast_for_text [pass(text: text, b1: 8, b2: 8)], text
  end

  def test_book_with_only_one_chapter
    text = 'Obad 3'
    assert_parsed_ast_for_text [pass(text: text, b1: 31, c1: 1, v1: 3, b2: 31, c2: 1, v2: 3)], text
    text = 'Obad 1,3'
    assert_parsed_ast_for_text [pass(text: text, b1: 31, c1: 1, v1: 3, b2: 31, c2: 1, v2: 3)], text
    text = 'Obad 1'
    assert_parsed_ast_for_text [pass(text: text, b1: 31, c1: 1, v1: 1, b2: 31, c2: 1, v2: 1)], text
    text = 'Obad 1,1'
    assert_parsed_ast_for_text [pass(text: text, b1: 31, c1: 1, v1: 1, b2: 31, c2: 1, v2: 1)], text
  end

  def test_book_with_only_one_chapter_range
    text = 'Obad 3-5'
    assert_parsed_ast_for_text [pass(text: text, b1: 31, c1: 1, v1: 3, b2: 31, c2: 1, v2: 5)], text
    text = 'Obad 1,3-5'
    assert_parsed_ast_for_text [pass(text: text, b1: 31, c1: 1, v1: 3, b2: 31, c2: 1, v2: 5)], text
    text = 'Obad 1-4'
    assert_parsed_ast_for_text [pass(text: text, b1: 31, c1: 1, v1: 1, b2: 31, c2: 1, v2: 4)], text
    text = 'Obad 1,1-4'
    assert_parsed_ast_for_text [pass(text: text, b1: 31, c1: 1, v1: 1, b2: 31, c2: 1, v2: 4)], text
  end

  def test_book_with_only_one_chapter_at_begin_of_range
    text = 'Obad - Jona'
    assert_parsed_ast_for_text [pass(text: text, b1: 31, c1: 1, b2: 32)], text
    text = 'Obad 3 - Jona 2,4'
    assert_parsed_ast_for_text [pass(text: text, b1: 31, c1: 1, v1: 3, b2: 32, c2: 2, v2: 4)], text
    text = 'Obad 1,3 - Jona 2,4'
    assert_parsed_ast_for_text [pass(text: text, b1: 31, c1: 1, v1: 3, b2: 32, c2: 2, v2: 4)], text
  end

  def test_book_with_only_one_chapter_at_end_of_range
    text = 'Amos 2,4 - Obad 3'
    assert_parsed_ast_for_text [pass(text: text, b1: 30, c1: 2, v1: 4, b2: 31, c2: 1, v2: 3)], text
    text = 'Amos 2,4 - Obad 1,3'
    assert_parsed_ast_for_text [pass(text: text, b1: 30, c1: 2, v1: 4, b2: 31, c2: 1, v2: 3)], text
    text = 'Amos 2,4 - Obad 1'
    assert_parsed_ast_for_text [pass(text: text, b1: 30, c1: 2, v1: 4, b2: 31, c2: 1, v2: 1)], text
    text = 'Amos 2,4 - Obad 1,1'
    assert_parsed_ast_for_text [pass(text: text, b1: 30, c1: 2, v1: 4, b2: 31, c2: 1, v2: 1)], text
  end

  ######################################################################
  # more than one passage
  ######################################################################

  def test_two_books
    text = 'Ruth; Markus'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(text: t1, b1: 8, b2: 8), semi, pass(text: t2, b1: 41, b2: 41)], text
  end

  def test_two_complete_refs
    text = 'Ruth 2,1; Markus 4,8'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(text: t1, b1: 8, c1: 2, v1: 1, b2: 8, c2: 2, v2: 1), semi, pass(text: t2, b1: 41, c1: 4, v1: 8, b2: 41, c2: 4, v2: 8)], text
  end

  def test_two_refs_same_book
    text = 'Ruth 2,1; 5,4'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(text: t1, b1: 8, c1: 2, v1: 1, b2: 8, c2: 2, v2: 1), semi, pass(text: t2, b1: 8, c1: 5, v1: 4, b2: 8, c2: 5, v2: 4)], text
  end

  def test_two_chapters_same_book
    text = 'Ruth 2; 5'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(text: t1, b1: 8, c1: 2, b2: 8, c2: 2), semi, pass(text: t2, b1: 8, c1: 5, b2: 8, c2: 5)], text
  end

  def test_two_chapters_different_book
    text = 'Ruth 2; Markus 4'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(text: t1, b1: 8, c1: 2, b2: 8, c2: 2), semi, pass(text: t2, b1: 41, c1: 4, b2: 41, c2: 4)], text
  end

  def test_two_verses
    text = 'Ruth 2,5.11'
    t1, t2 = text.split(dot)
    assert_parsed_ast_for_text [pass(text: t1, b1: 8, c1: 2, v1: 5, b2: 8, c2: 2, v2: 5), dot, pass(text: t2, b1: 8, c1: 2, v1: 11, b2: 8, c2: 2, v2: 11)], text
  end

  def test_partial_passage_after_full_passage
    text = 'Ruth 2,5; 4'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(text: t1, b1: 8, c1: 2, v1: 5, b2: 8, c2: 2, v2: 5), semi, pass(text: t2, b1: 8, c1: 4, b2: 8, c2: 4)], text
    text = 'Ruth 2,5; Markus'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(text: t1, b1: 8, c1: 2, v1: 5, b2: 8, c2: 2, v2: 5), semi, pass(text: t2, b1: 41, b2: 41)], text
    text = 'Ruth 2,5; Markus 4'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(text: t1, b1: 8, c1: 2, v1: 5, b2: 8, c2: 2, v2: 5), semi, pass(text: t2, b1: 41, c1: 4, b2: 41, c2: 4)], text
  end

  ######################################################################
  # mixed variants of more than one passage
  ######################################################################

  def test_verse_range_and_separated_verse
    text = 'Ruth 2,1-3.11'
    t1, t2 = text.split(dot)
    assert_parsed_ast_for_text [pass(text: t1, b1: 8, c1: 2, v1: 1, b2: 8, c2: 2, v2: 3), dot, pass(text: t2, b1: 8, c1: 2, v1: 11, b2: 8, c2: 2, v2: 11)], text
  end

  def test_separate_verse_and_verse_range
    text = 'Ruth 2,1.3-11'
    t1, t2 = text.split(dot)
    assert_parsed_ast_for_text [pass(text: t1, b1: 8, c1: 2, v1: 1, b2: 8, c2: 2, v2: 1), dot, pass(text: t2, b1: 8, c1: 2, v1: 3, b2: 8, c2: 2, v2: 11)], text
  end

  def test_two_verse_ranges
    text = 'Ruth 2,1-3.7-11'
    t1, t2 = text.split(dot)
    assert_parsed_ast_for_text [pass(text: t1, b1: 8, c1: 2, v1: 1, b2: 8, c2: 2, v2: 3), dot, pass(text: t2, b1: 8, c1: 2, v1: 7, b2: 8, c2: 2, v2: 11)], text
  end

  def test_two_verse_range_different_books
    text = 'Ruth 2,1-11; Markus 4,3-7'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(text: t1, b1: 8, c1: 2, v1: 1, b2: 8, c2: 2, v2: 11), semi, pass(text: t2, b1: 41, c1: 4, v1: 3, b2: 41, c2: 4, v2: 7)], text
  end

  def test_two_verse_range_different_chapters
    text = 'Ruth 2,1-11; 3,10-19'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(text: t1, b1: 8, c1: 2, v1: 1, b2: 8, c2: 2, v2: 11), semi, pass(text: t2, b1: 8, c1: 3, v1: 10, b2: 8, c2: 3, v2: 19)], text
  end

  def test_book_range_and_following_book
    text = 'Ruth-Markus; Johannes'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(text: t1, b1: 8, b2: 41), semi, pass(text: t2, b1: 43, b2: 43)], text
  end

  def test_chapter_range_and_following_book
    text = 'Ruth 1-2; Joh 4'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(text: t1, b1: 8, c1: 1, b2: 8, c2: 2), semi, pass(text: t2, b1: 43, c1: 4, b2: 43, c2: 4)], text
  end

  def test_chapter_range_and_following_chapter
    text = 'Ruth 1-2; 4'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(text: t1, b1: 8, c1: 1, b2: 8, c2: 2), semi, pass(text: t2, b1: 8, c1: 4, b2: 8, c2: 4)], text
  end

  def test_book_only_after_full_passage
    text = 'Matt 3,4; Mar; Joh 3,16'
    t1, t2, t3 = text.split(semi)
    assert_parsed_ast_for_text [pass(text: t1, b1: 40, c1: 3, v1: 4, b2: 40, c2: 3, v2: 4), semi, pass(text: t2, b1: 41, b2: 41), semi, pass(text: t3, b1: 43, c1: 3, v1: 16, b2: 43, c2: 3, v2: 16)], text
  end

  def test_chapter_only_after_full_passage
    text = 'Matt 3,4; 8; Joh 3,16'
    t1, t2, t3 = text.split(semi)
    assert_parsed_ast_for_text [pass(text: t1, b1: 40, c1: 3, v1: 4, b2: 40, c2: 3, v2: 4), semi, pass(text: t2, b1: 40, c1: 8, b2: 40, c2: 8), semi, pass(text: t3, b1: 43, c1: 3, v1: 16, b2: 43, c2: 3, v2: 16)], text
  end

  ######################################################################
  # complex variants of references
  ######################################################################

  def test_complex_example
    text = 'Ruth 2,1-11.15; 3,7.9-12; Markus 4; 5,3.18-21'
    t1, t2, t3, t4, t5, t6, t7 = text.split(/; |\./)
    ast = [
      pass(text: t1, b1: 8, c1: 2, v1: 1, b2: 8, c2: 2, v2: 11), dot,
      pass(text: t2, b1: 8, c1: 2, v1: 15, b2: 8, c2: 2, v2: 15), semi,
      pass(text: t3, b1: 8, c1: 3, v1: 7, b2: 8, c2: 3, v2: 7), dot,
      pass(text: t4, b1: 8, c1: 3, v1: 9, b2: 8, c2: 3, v2: 12), semi,
      pass(text: t5, b1: 41, c1: 4, b2: 41, c2: 4), semi,
      pass(text: t6, b1: 41, c1: 5, v1: 3, b2: 41, c2: 5, v2: 3), dot,
      pass(text: t7, b1: 41, c1: 5, v1: 18, b2: 41, c2: 5, v2: 21)
    ]
    assert_parsed_ast_for_text ast, text
  end

  ######################################################################
  # malformed references
  ######################################################################

  def test_exception_and_error_message
    text = 'Ruth 2,x'
    assert_raise ParserError do
      @parser.parse text
    end
    assert_equal 'Verse expected!', @parser.error
    formated_error = "Verse expected!\nRuth 2,x\n       ^"
    assert_equal formated_error, @parser.format_error
  end

  def test_exception_and_error_message_for_ambiguous_book
    text = 'Ruth 2,4; M 3,8'
    assert_raise ParserError do
      @parser.parse text
    end
    assert_match /^Abbreviation M is ambiguous/, @parser.error
    formated_error = "Abbreviation M is ambiguous it matches Micha, Maleachi, Matthäus, Markus!\nRuth 2,4; M 3,8\n          ^"
    assert_equal formated_error, @parser.format_error
  end

  ######################################################################
  # special things
  ######################################################################

  def test_special_book_abbrev
    # Abbreviation "Phil" would technical match "Philipper" and "Philemon"
    # and therefore throw a ParserError because it's ambiguous,
    # but in German the abbrev "Phil" is generally used for "Philipper",
    # so the parser should be able to support such behaviour.
    text = 'Phil 4,4'
    assert_parsed_ast_for_text [pass(text: text, b1: 50, c1: 4, v1: 4, b2: 50, c2: 4, v2: 4)], text
    # It must also work with a dot
    text = 'Phil. 4,4'
    assert_parsed_ast_for_text [pass(text: text, b1: 50, c1: 4, v1: 4, b2: 50, c2: 4, v2: 4)], text
  end

  def test_book_abbrev_which_seems_to_be_ambiguous
    # Abbreviation 'Psm' matches 'Psalm' and 'Psalmen' which is the same
    # book so it is not an ambiguous error.
    text = 'Psm 23,6'
    assert_parsed_ast_for_text [pass(text: text, b1: 19, c1: 23, v1: 6, b2: 19, c2: 23, v2: 6)], text
  end

  private

  def assert_equal_passage expected, actual
    assert_equal expected.text, actual.text, 'Parsed text'
    assert_equal expected.b1, actual.b1, 'First book'
    assert_equal expected.c1, actual.c1, 'First chapter'
    assert_equal expected.v1, actual.v1, 'First verse'
    assert_equal expected.b2, actual.b2, 'Second book'
    assert_equal expected.c2, actual.c2, 'Second chapter'
    assert_equal expected.v2, actual.v2, 'Second verse'
    assert_equal expected.a1, actual.a1, 'First addon'
    assert_equal expected.a2, actual.a2, 'Second addon'
  end

  def assert_parsed_ast_for_text expected_ast, text
    res = @parser.parse(text)
    assert_equal expected_ast.size, res.size, 'Array size of AST'
    expected_ast.zip(res) do |expected_elem, actual_elem|
      if expected_elem.kind_of?(Passage)
        assert_equal_passage expected_elem, actual_elem
      else
        assert_equal expected_elem, actual_elem
      end
    end
  end

  def assert_parser_error msg
    assert_raise ParserError do
      yield
    end
    assert_equal msg, @parser.error
  end

end
