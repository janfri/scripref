# - encoding: utf-8 -
require 'test/unit'
require 'scripref'

class TestParser < Test::Unit::TestCase

  def setup
    @parser = Scripref::Parser.new(Scripref::German)
  end

  def test_only_book
    text = 'Ruth'
    assert_parsed_ast_for_text [pass(text, 8, 1, 1, 8, :max, :max)], text
  end

  def test_book_and_chapter
    text = 'Ruth 2'
    assert_parsed_ast_for_text [pass(text, 8, 2, 1, 8, 2, :max)], text
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
    assert_parsed_ast_for_text [pass(text, 8, 2, 1, 8, 3, :max)], text
  end

  def test_one_following_verse
    text = 'Ruth 2,5f'
    assert_parsed_ast_for_text [pass(text, 8, 2, 5, 8, 2, :f)], text
  end

  def test_more_following_verse
    text = 'Ruth 2,5ff'
    assert_parsed_ast_for_text [pass(text, 8, 2, 5, 8, 2, :ff)], text
  end

  ######################################################################
  # more than one reference
  ######################################################################

  def test_two_complete_refs
    text = 'Ruth 2,1; Markus 4,8'
    t1, t2 = text.split('; ')
    assert_parsed_ast_for_text [pass(t1, 8, 2, 1, 8, 2, 1), '; ', pass(t2, 41, 4, 8, 41, 4, 8)], text
  end

  def test_two_refs_same_book
    text = 'Ruth 2,1; 5,4'
    t1, t2 = text.split('; ')
    assert_parsed_ast_for_text [pass(t1, 8, 2, 1, 8, 2, 1), '; ', pass(t2, 8, 5, 4, 8, 5, 4)], text
  end

  def test_two_chapters_same_book
    text = 'Ruth 2; 5'
    t1, t2 = text.split('; ')
    assert_parsed_ast_for_text [pass(t1, 8, 2, 1, 8, 2, :max), '; ', pass(t2, 8, 5, 1, 8, 5, :max)], text
  end

  def test_two_chapters_different_book
    text = 'Ruth 2; Markus 4'
    t1, t2 = text.split('; ')
    assert_parsed_ast_for_text [pass(t1, 8, 2, 1, 8, 2, :max), '; ', pass(t2, 41, 4, 1, 41, 4, :max)], text
  end

  def test_two_verses
    text = 'Ruth 2,5.11'
    t1, t2 = text.split('.')
    assert_parsed_ast_for_text [pass(t1, 8, 2, 5, 8, 2, 5), '.', pass(t2, 8, 2, 11, 8, 2, 11)], text
  end

  ######################################################################
  # mixed variants of more than one reference
  ######################################################################

  def test_verse_range_and_separated_verse
    text = 'Ruth 2,1-3.11'
    t1, t2 = text.split('.')
    assert_parsed_ast_for_text [pass(t1, 8, 2, 1, 8, 2, 3), '.', pass(t2, 8, 2, 11, 8, 2, 11)], text
  end

  def test_separate_verse_and_verse_range
    text = 'Ruth 2,1.3-11'
    t1, t2 = text.split('.')
    assert_parsed_ast_for_text [pass(t1, 8, 2, 1, 8, 2, 1), '.', pass(t2, 8, 2, 3, 8, 2, 11)], text
  end

  def test_two_verse_ranges
    text = 'Ruth 2,1-3.7-11'
    t1, t2 = text.split('.')
    assert_parsed_ast_for_text [pass(t1, 8, 2, 1, 8, 2, 3), '.', pass(t2, 8, 2, 7, 8, 2, 11)], text
  end

  def test_two_verse_range_different_books
    text = 'Ruth 2,1-11; Markus 4,3-7'
    t1, t2 = text.split('; ')
    assert_parsed_ast_for_text [pass(t1, 8, 2, 1, 8, 2, 11), '; ', pass(t2, 41, 4, 3,41, 4, 7)], text
  end

  def test_two_verse_range_different_chapters
    text = 'Ruth 2,1-11; 3,10-19'
    t1, t2 = text.split('; ')
    assert_parsed_ast_for_text [pass(t1, 8, 2, 1, 8, 2, 11), '; ', pass(t2, 8, 3, 10, 8, 3, 19)], text
  end

  ######################################################################
  # complex variants of references
  ######################################################################

  def test_complex_example
    text = 'Ruth 2,1-11.15; 3,7.9-12; Markus 4; 5,3.18-21'
    t1, t2, t3, t4, t5, t6, t7 = text.split(/; |\./)
    ast = [
      pass(t1, 8, 2, 1, 8, 2, 11), '.',
      pass(t2, 8, 2, 15, 8, 2, 15), '; ',
      pass(t3, 8, 3, 7, 8, 3, 7), '.',
      pass(t4, 8, 3, 9, 8, 3, 12), '; ',
      pass(t5, 41, 4, 1, 41, 4, :max), '; ',
      pass(t6, 41, 5, 3, 41, 5, 3), '.',
      pass(t7, 41, 5, 18, 41, 5, 21)
    ]
    assert_parsed_ast_for_text ast, text
  end

  protected

  def pass *args
    Scripref::Passage.new(*args)
  end

  def assert_equal_passage expected, actual
    assert_equal expected.text, actual.text, 'Parsed text'
    assert_equal expected.b1, actual.b1, 'First book'
    assert_equal expected.c1, actual.c1, 'First chapter'
    assert_equal expected.v1, actual.v1, 'First verse'
    assert_equal expected.b2, actual.b2, 'Second book'
    assert_equal expected.c2, actual.c2, 'Second chapter'
    assert_equal expected.v2, actual.v2, 'Second verse'
  end

  def assert_parsed_ast_for_text expected_ast, text
    res = @parser.parse(text)
    assert_equal expected_ast.size, res.size, 'Array size of AST'
    expected_ast.zip(res) do |expected_elem, actual_elem|
      if !expected_elem.kind_of?(String)
        assert_equal_passage expected_elem, actual_elem
      else
        assert_equal expected_elem, actual_elem
      end
    end
  end

end
