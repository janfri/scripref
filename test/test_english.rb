# encoding: utf-8
# frozen_string_literal: true

require_relative 'test_helper'

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

  def test_book2osis_id
    assert_osis_book_id :Gen, 'Genesis'
    assert_osis_book_id :Matt, 'Matthew'
    assert_osis_book_id :Rev, 'Revelation'
    assert_osis_book_id :Gen, 'Gen'
    assert_osis_book_id :Gen, 'Ge'
    assert_osis_book_id :'2Tim', '2 Tim'
    assert_osis_book_id :'2Tim', '2Tim'
    assert_osis_book_id :'2Tim', '2Tm'
    assert_osis_book_id :Matt, 'Mat'
    assert_osis_book_id :Rev, 'Rev'
  end

  def assert_osis_book_id id, str
    assert_equal id, @parser.parse(str).first.b1
  end

end
