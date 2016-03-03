# - encoding: utf-8 -
require 'test/unit'
require 'test_helper'
require 'scripref'

class TestParser < Test::Unit::TestCase

  include Test::Helper

  def setup
    @parser = Scripref::Parser.new(Scripref::German)
  end

  def test_only_book
    text = 'Ruth'
    assert_parsed_ast_for_text [pass(text, 8, nil, nil, 8, nil, nil)], text
  end

  def test_ambiguous_book
    msg = 'Abbreviation Jo is ambiguous it matches Josua, Joel, Jona, Johannes, Jakobus!'
    assert_parser_error msg do
      @parser.parse 'Jo'
    end
  end

  def test_book_and_chapter
    text = 'Ruth 2'
    assert_parsed_ast_for_text [pass(text, 8, 2, nil, 8, 2, nil)], text
  end

  def test_book_chapter_and_verse
    text = 'Ruth 2,5'
    assert_parsed_ast_for_text [pass(text, 8, 2, 5, 8, 2, 5)], text
  end

  def test_verse_range
    text = 'Ruth 2,5-11'
    assert_parsed_ast_for_text [pass(text, 8, 2, 5, 8, 2, 11)], text
  end

  def test_chapter_verse_range
    text = 'Ruth 2,5-3,7'
    assert_parsed_ast_for_text [pass(text, 8, 2, 5, 8, 3, 7)], text
  end

  def test_chapter_range
    text = 'Ruth 2-3'
    assert_parsed_ast_for_text [pass(text, 8, 2, nil, 8, 3, nil)], text
  end

  def test_book_range
    text = '1. Mose - Offenbarung'
    assert_parsed_ast_for_text [pass(text, 1, nil, nil, 66, nil, nil)], text
  end

  def test_book_chapter_range
    text = '1. Mose 1 - Offenbarung 22'
    assert_parsed_ast_for_text [pass(text, 1, 1, nil, 66, 22, nil)], text
  end

  def test_book_chapter_verse_range
    text = '1. Mose 1,1-Offenbarung 22,21'
    assert_parsed_ast_for_text [pass(text, 1, 1, 1, 66, 22, 21)], text
  end

  def test_one_following_verse
    text = 'Ruth 2,5f'
    assert_parsed_ast_for_text [pass(text, 8, 2, 5, 8, 2, :f)], text
  end

  def test_more_following_verse
    text = 'Ruth 2,5ff'
    assert_parsed_ast_for_text [pass(text, 8, 2, 5, 8, 2, :ff)], text
  end

  def test_first_addon
    text = 'Ruth 2,5a'
    assert_parsed_ast_for_text [pass(text, 8, 2, 5, 8, 2, 5, a1: :a)], text
  end

  def test_second_addon
    text = 'Ruth 2,5-7a'
    assert_parsed_ast_for_text [pass(text, 8, 2, 5, 8, 2, 7, a2: :a)], text
  end

  def test_both_addons
    text = 'Ruth 2,5b-7a'
    assert_parsed_ast_for_text [pass(text, 8, 2, 5, 8, 2, 7, a1: :b, a2: :a)], text
  end

  def test_reset_addons
    @parser.parse 'Ruth 2,5b-7a'
    text = 'Ruth'
    assert_parsed_ast_for_text [pass(text, 8, nil, nil, 8, nil, nil)], text
  end

  def test_book_with_only_one_chapter
    text = 'Obad 3'
    assert_parsed_ast_for_text [pass(text, 31, 1, 3, 31, 1, 3)], text
    text = 'Obad 1,3'
    assert_parsed_ast_for_text [pass(text, 31, 1, 3, 31, 1, 3)], text
    text = 'Obad 1'
    assert_parsed_ast_for_text [pass(text, 31, 1, 1, 31, 1, 1)], text
    text = 'Obad 1,1'
    assert_parsed_ast_for_text [pass(text, 31, 1, 1, 31, 1, 1)], text
  end

  def test_book_with_only_one_chapter_range
    text = 'Obad 3-5'
    assert_parsed_ast_for_text [pass(text, 31, 1, 3, 31, 1, 5)], text
    text = 'Obad 1,3-5'
    assert_parsed_ast_for_text [pass(text, 31, 1, 3, 31, 1, 5)], text
    text = 'Obad 1-4'
    assert_parsed_ast_for_text [pass(text, 31, 1, 1, 31, 1, 4)], text
    text = 'Obad 1,1-4'
    assert_parsed_ast_for_text [pass(text, 31, 1, 1, 31, 1, 4)], text
  end

  def test_book_with_only_one_chapter_at_begin_of_range
    text = 'Obad - Jona'
    assert_parsed_ast_for_text [pass(text, 31, 1, nil, 32, nil, nil)], text
    text = 'Obad 3 - Jona 2,4'
    assert_parsed_ast_for_text [pass(text, 31, 1, 3, 32, 2, 4)], text
    text = 'Obad 1,3 - Jona 2,4'
    assert_parsed_ast_for_text [pass(text, 31, 1, 3, 32, 2, 4)], text
  end

  def test_book_with_only_one_chapter_at_end_of_range
    text = 'Amos 2,4 - Obad 3'
    assert_parsed_ast_for_text [pass(text, 30, 2, 4, 31, 1, 3)], text
    text = 'Amos 2,4 - Obad 1,3'
    assert_parsed_ast_for_text [pass(text, 30, 2, 4, 31, 1, 3)], text
    text = 'Amos 2,4 - Obad 1'
    assert_parsed_ast_for_text [pass(text, 30, 2, 4, 31, 1, 1)], text
    text = 'Amos 2,4 - Obad 1,1'
    assert_parsed_ast_for_text [pass(text, 30, 2, 4, 31, 1, 1)], text
  end

  ######################################################################
  # more than one reference
  ######################################################################

  def test_two_books
    text = 'Ruth; Markus'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(t1, 8, nil, nil, 8, nil, nil), semi, pass(t2, 41, nil, nil, 41, nil, nil)], text
  end

  def test_two_complete_refs
    text = 'Ruth 2,1; Markus 4,8'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(t1, 8, 2, 1, 8, 2, 1), semi, pass(t2, 41, 4, 8, 41, 4, 8)], text
  end

  def test_two_refs_same_book
    text = 'Ruth 2,1; 5,4'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(t1, 8, 2, 1, 8, 2, 1), semi, pass(t2, 8, 5, 4, 8, 5, 4)], text
  end

  def test_two_chapters_same_book
    text = 'Ruth 2; 5'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(t1, 8, 2, nil, 8, 2, nil), semi, pass(t2, 8, 5, nil, 8, 5, nil)], text
  end

  def test_two_chapters_different_book
    text = 'Ruth 2; Markus 4'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(t1, 8, 2, nil, 8, 2, nil), semi, pass(t2, 41, 4, nil, 41, 4, nil)], text
  end

  def test_two_verses
    text = 'Ruth 2,5.11'
    t1, t2 = text.split(dot)
    assert_parsed_ast_for_text [pass(t1, 8, 2, 5, 8, 2, 5), dot, pass(t2, 8, 2, 11, 8, 2, 11)], text
  end

  def test_partial_passage_after_full_passage
    text = 'Ruth 2,5; Markus'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(t1, 8, 2, 5, 8, 2, 5), semi, pass(t2, 41, nil, nil, 41, nil, nil)], text
    text = 'Ruth 2,5; Markus 4'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(t1, 8, 2, 5, 8, 2, 5), semi, pass(t2, 41, 4, nil, 41, 4, nil)], text
  end

  ######################################################################
  # mixed variants of more than one reference
  ######################################################################

  def test_verse_range_and_separated_verse
    text = 'Ruth 2,1-3.11'
    t1, t2 = text.split(dot)
    assert_parsed_ast_for_text [pass(t1, 8, 2, 1, 8, 2, 3), dot, pass(t2, 8, 2, 11, 8, 2, 11)], text
  end

  def test_separate_verse_and_verse_range
    text = 'Ruth 2,1.3-11'
    t1, t2 = text.split(dot)
    assert_parsed_ast_for_text [pass(t1, 8, 2, 1, 8, 2, 1), dot, pass(t2, 8, 2, 3, 8, 2, 11)], text
  end

  def test_two_verse_ranges
    text = 'Ruth 2,1-3.7-11'
    t1, t2 = text.split(dot)
    assert_parsed_ast_for_text [pass(t1, 8, 2, 1, 8, 2, 3), dot, pass(t2, 8, 2, 7, 8, 2, 11)], text
  end

  def test_two_verse_range_different_books
    text = 'Ruth 2,1-11; Markus 4,3-7'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(t1, 8, 2, 1, 8, 2, 11), semi, pass(t2, 41, 4, 3,41, 4, 7)], text
  end

  def test_two_verse_range_different_chapters
    text = 'Ruth 2,1-11; 3,10-19'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(t1, 8, 2, 1, 8, 2, 11), semi, pass(t2, 8, 3, 10, 8, 3, 19)], text
  end

  def test_book_range_and_following_book
    text = 'Ruth-Markus; Johannes'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(t1, 8, nil, nil, 41, nil, nil), semi, pass(t2, 43, nil, nil, 43, nil, nil)], text
  end

  def test_chapter_range_and_following_book
    text = 'Ruth 1-2; Joh 4'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(t1, 8, 1, nil, 8, 2, nil), semi, pass(t2, 43, 4, nil, 43, 4, nil)], text
  end

  def test_chapter_range_and_following_chapter
    text = 'Ruth 1-2; 4'
    t1, t2 = text.split(semi)
    assert_parsed_ast_for_text [pass(t1, 8, 1, nil, 8, 2, nil), semi, pass(t2, 8, 4, nil, 8, 4, nil)], text
  end

  def test_book_only_after_full_passage
    text = 'Matt 3,4; Mar; Joh 3,16'
    t1, t2, t3 = text.split(semi)
    assert_parsed_ast_for_text [pass(t1, 40, 3, 4, 40, 3, 4), semi, pass(t2, 41, nil, nil, 41, nil, nil), semi, pass(t3, 43, 3, 16, 43, 3, 16)], text
  end

  def test_chapter_only_after_full_passage
    text = 'Matt 3,4; 8; Joh 3,16'
    t1, t2, t3 = text.split(semi)
    assert_parsed_ast_for_text [pass(t1, 40, 3, 4, 40, 3, 4), semi, pass(t2, 40, 8, nil, 40, 8, nil), semi, pass(t3, 43, 3, 16, 43, 3, 16)], text
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
    assert_parsed_ast_for_text ast, text
  end

  ######################################################################
  # malformed references
  ######################################################################

  def test_error_message
    text = 'Ruth 2,x'
    begin
      @parser.parse text
    rescue Scripref::ParserError
    end
    assert_equal 'Verse expected!', @parser.error
    formated_error = "Verse expected!\nRuth 2,x\n       ^"
    assert_equal formated_error, @parser.format_error
  end

  def test_error_message_for_unambiguous_book
    text = 'Ruth 2,4; M 3,8'
    begin
      @parser.parse text
    rescue Scripref::ParserError
    end
    assert_match /^Abbreviation M is ambiguous/, @parser.error
    formated_error = "Abbreviation M is ambiguous it matches Micha, Maleachi, Matthäus, Markus!\nRuth 2,4; M 3,8\n          ^"
    assert_equal formated_error, @parser.format_error
  end

  ######################################################################
  # special things
  ######################################################################

  def test_special_book_abbrev
    # Abbrev "Phil" would technical match "Philipper" and "Philemon"
    # and therefore throw a ParserError because it's ambiguous,
    # but in German the abbrev "Phil" is generally used for "Philipper",
    # so the parser should be able to support such behaviour.
    text = 'Phil 4,4'
    assert_parsed_ast_for_text [pass(text, 50, 4, 4, 50, 4, 4)], text
  end

end
