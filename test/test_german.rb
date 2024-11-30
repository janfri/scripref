# encoding: utf-8
# frozen_string_literal: true

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

  def test_book2osis_id
    assert_osis_book_id :Gen, '1. Mose'
    assert_osis_book_id :Matt, 'Matthäus'
    assert_osis_book_id :Rev, 'Offenbarung'
    assert_osis_book_id :Gen, '1. Mo'
    assert_osis_book_id :Gen, '1.Mo'
    assert_osis_book_id :Gen, '1M'
    assert_osis_book_id :Matt, 'Mat'
    assert_osis_book_id :Phil, 'Phil'
    assert_osis_book_id :Rev, 'Off'
  end

  def assert_osis_book_id id, str
    @parser ||= Scripref::Parser.new(Scripref::German)
    assert_equal id, @parser.parse(str).first.b1
  end

end
