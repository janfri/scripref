# - encoding: utf-8 -
require 'test/unit'
require 'test_helper'
require 'scripref/english'

class TestEnglish < Test::Unit::TestCase

  include Test::Helper
  include Scripref::English

  def test_book_re
    assert_match book_re, 'Genesis'
    assert_match book_re, 'Exodus'
    assert_match book_re, 'Matthew'
    assert_match book_re, '2 Timothy'
    assert_not_match book_re, '2 2 Timothy'
    assert_match book_re, 'Revelation'
    assert_not_match book_re, 'something'
    assert_match book_re, 'Gen'
    assert_match book_re, 'Ex'
    assert_match book_re, 'Mat'
    assert_match book_re, '2 Tim'
    assert_match book_re, 'Rev'
  end

  def test_book2num
    assert_book_num 1, 'Genesis'
    assert_book_num 40, 'Matthew'
    assert_book_num 66, 'Revelation'
    assert_book_num 1, 'Gen'
    assert_book_num 1, 'Ge'
    assert_book_num 1, 'G'
    assert_book_num 55, '2 Tim'
    assert_book_num 55, '2Tim'
    assert_book_num 55, '2Tm'
    assert_book_num 40, 'Mat'
    assert_book_num 66, 'Rev'
  end

  def assert_book_num num, str
    @parser ||= Scripref::Parser.new(Scripref::English)
    assert_equal num, @parser.parse(str).first.b1
  end

  def test_book_with_only_one_chapter
    @parser ||= Scripref::Parser.new(Scripref::English)
    text = 'Obad 1:3'
    ast = [pass(text, 31, 1, 3, 31, 1, 3)]
    assert_parsed_ast_for_text ast, text
  end

end
