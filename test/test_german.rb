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
    assert_match 'Offenbarung', book_re
    assert_not_match 'something', book_re
    assert_match '1. Mo', book_re
    assert_match '2.Mo', book_re
    assert_match 'Mat', book_re
    assert_match '2. Tim', book_re
    assert_match 'Off', book_re
  end

  def test_book2num
    assert_equal 1, book2num('1. Mose')
    assert_equal 40, book2num('Matthäus')
    assert_equal 66, book2num('Offenbarung')
    assert_equal 1, book2num('1. Mo')
    assert_equal 1, book2num('1.Mo')
    assert_equal 1, book2num('1M')
    assert_equal 40, book2num('Mat')
    assert_equal 66, book2num('Off')
  end

end
