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
  end

end
