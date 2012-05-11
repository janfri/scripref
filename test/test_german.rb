# - encoding: utf-8 -
require 'test/unit'
require 'scripref/german'

class TestGerman < Test::Unit::TestCase

  include Scripref::German

  def test_book_re
    assert_match book_re, '1. Mose'
    assert_match book_re, '2. Mose'
    assert_match book_re, 'Matthäus'
    assert_match book_re, '2. Timotheus'
    assert_not_match book_re, '2. 2. Timotheus'
    assert_match book_re, 'Offenbarung'
    assert_not_match book_re, 'something'
    assert_match book_re, '1. Mo'
    assert_match book_re, '2.Mo'
    assert_match book_re, 'Mat'
    assert_match book_re, '2. Tim'
    assert_match book_re, 'Off'
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
