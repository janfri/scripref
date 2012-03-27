# - encoding: utf-8 -
require 'test/unit'
require 'scripref/english'

class TestEnglish < Test::Unit::TestCase

  include Scripref::English

  def test_book_re
    assert_match 'Genesis', book_re
    assert_match 'Exodus', book_re
    assert_match 'Matthew', book_re
    assert_match '2 Timothy', book_re
    assert_not_match '2 2 Timothy', book_re
    assert_match 'Revelation', book_re
    assert_not_match 'something', book_re
    assert_match 'Gen', book_re
    assert_match 'Ex', book_re
    assert_match 'Mat', book_re
    assert_match '2 Tim', book_re
    assert_match 'Rev', book_re
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

end
