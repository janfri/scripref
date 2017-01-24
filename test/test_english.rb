# - encoding: utf-8 -
require 'test_helper'

class TestEnglish < Test::Unit::TestCase

  include Scripref
  include Test::Helper

  def setup
    @parser = Parser.new(English)
  end

  def test_size_of_book_array
    assert_equal 66, English::BOOK_NAMES.size
  end

  def test_book_re
    book_re = @parser.book_re
    assert_match book_re, 'Genesis'
    assert_match book_re, 'Exodus'
    assert_match book_re, 'Matthew'
    assert_match book_re, '2 Timothy'
    assert_not_match book_re, 'x2 Timothy'
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
    assert_book_num 55, '2 Tim'
    assert_book_num 55, '2Tim'
    assert_book_num 55, '2Tm'
    assert_book_num 40, 'Mat'
    assert_book_num 66, 'Rev'
  end

  def assert_book_num num, str
    assert_equal num, @parser.parse(str).first.b1
  end

end
