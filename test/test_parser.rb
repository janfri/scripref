# - encoding: utf-8 -
require 'test/unit'
require 'scripref'

class TestParser < Test::Unit::TestCase

  def setup
    @parser = Scripref::Parser.new(Scripref::German)
  end

  def test_only_book
    text = 'Ruth'
    assert_parsed_ast_for_text [Scripref::Passage.new(text, 8, 1, 1, 8, :max, :max)], text
  end

  def test_book_and_chapter
    text ='Ruth 2'
    assert_parsed_ast_for_text [Scripref::Passage.new(text, 8, 2, 1, 8, 2, :max)], text
  end

  def test_book_chapter_and_verse
    text ='Ruth 2,5'
    assert_parsed_ast_for_text [Scripref::Passage.new(text, 8, 2, 5, 8, 2, 5)], text
  end

  def test_verse_range
    text ='Ruth 2,5-11'
    assert_parsed_ast_for_text [Scripref::Passage.new(text, 8, 2, 5, 8, 2, 11)], text
  end

  def test_chapter_verse_range
    text ='Ruth 2,5-3,7'
    assert_parsed_ast_for_text [Scripref::Passage.new(text, 8, 2, 5, 8, 3, 7)], text
  end

  def test_chapter_range
    text ='Ruth 2-3'
    assert_parsed_ast_for_text [Scripref::Passage.new(text, 8, 2, 1, 8, 3, :max)], text
  end

  def test_two_complete_refs
    text = 'Ruth 2,1; Markus 4,8'
    t1, t2 = text.split('; ')
    assert_parsed_ast_for_text [Scripref::Passage.new(t1, 8, 2, 1, 8, 2, 1), '; ', Scripref::Passage.new(t2, 41, 4, 8, 41, 4, 8)], text
  end

  def test_two_refs_same_book
    text = 'Ruth 2,1; 5,4'
    t1, t2 = text.split('; ')
    assert_parsed_ast_for_text [Scripref::Passage.new(t1, 8, 2, 1, 8, 2, 1), '; ', Scripref::Passage.new(t2, 8, 5, 4, 8, 5, 4)], text
  end

  def test_two_chapters_same_book
    text = 'Ruth 2; 5'
    t1, t2 = text.split('; ')
    assert_parsed_ast_for_text [Scripref::Passage.new(t1, 8, 2, 1, 8, 2, :max), '; ', Scripref::Passage.new(t2, 8, 5, 1, 8, 5, :max)], text
  end

  protected

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
