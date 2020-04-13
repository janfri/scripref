# - encoding: utf-8 -
require 'test_helper'

class TestGerman < Test::Unit::TestCase

  include Scripref
  include Test::Helper

  def setup
    @parser = Parser.new(German)
  end

  def test_size_of_book_array
    assert_equal 66, German::BOOK_NAMES.size
  end

  def test_book_re
    book_re = @parser.book_re
    assert_match book_re, '1. Mose'
    assert_match book_re, '2. Mose'
    assert_match book_re, 'Matthäus'
    assert_match book_re, '2. Timotheus'
    assert_not_match book_re, 'x2. Timotheus'
    assert_match book_re, 'Offenbarung'
    assert_not_match book_re, 'something'
    assert_match book_re, '1. Mo'
    assert_match book_re, '2.Mo'
    assert_match book_re, 'Mat'
    assert_match book_re, '2. Tim'
    assert_match book_re, 'Off'
  end

  def test_book2num
    assert_book_num :Gen, '1. Mose'
    assert_book_num :Matt, 'Matthäus'
    assert_book_num :Rev, 'Offenbarung'
    assert_book_num :Gen, '1. Mo'
    assert_book_num :Gen, '1.Mo'
    assert_book_num :Gen, '1M'
    assert_book_num :Matt, 'Mat'
    assert_book_num :Phil, 'Phil'
    assert_book_num :Rev, 'Off'
  end

  def assert_book_num num, str
    @parser ||= Scripref::Parser.new(Scripref::German)
    assert_equal num, @parser.parse(str).first.b1
  end

end
