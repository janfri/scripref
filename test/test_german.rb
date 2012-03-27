# - encoding: utf-8 -
require 'test/unit'
require 'scripref/german'

class TestGerman < Test::Unit::TestCase

  include Scripref::German

  def test_book_re
    assert_match '1. Mose', book_re
    assert_match '2. Mose', book_re
    assert_match 'Matthäus', book_re
    assert_match '2. Timotheus', book_re
    assert_not_match '2. 2. Timotheus', book_re
    assert_match 'Offenbarung', book_re
    assert_not_match 'something', book_re
    assert_match '1. Mo', book_re
    assert_match '2.Mo', book_re
    assert_match 'Mat', book_re
    assert_match '2. Tim', book_re
    assert_match 'Off', book_re
  end

  def test_book2num
    assert_book_num 1, '1. Mose'
    assert_book_num 40, 'Matthäus'
    assert_book_num 66, 'Offenbarung'
    assert_book_num 1, '1. Mo'
    assert_book_num 1, '1.Mo'
    assert_book_num 1, '1M'
    assert_book_num 40, 'Mat'
    assert_book_num 66, 'Off'
  end

  def assert_book_num num, str
    @parser ||= Scripref::Parser.new(Scripref::German)
    assert_equal num, @parser.parse(str).first.b1
  end

end
