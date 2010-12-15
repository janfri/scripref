# - encoding: utf-8 -
require 'test/unit'
require 'scripref'

module Test::Helper

  def assert_array_size size, arr
    assert_kind_of Array, arr
    assert_equal size, arr.size, 'Array size'
  end

  def assert_equal_passage expected, actual
    assert_equal expected.text, actual.text, 'Parsed text'
    assert_equal expected.b1, actual.b1, 'First book'
    assert_equal expected.c1, actual.c1, 'First chapter'
    assert_equal expected.v1, actual.v1, 'First verse'
    assert_equal expected.b2, actual.b2, 'Second book'
    assert_equal expected.c2, actual.c2, 'Second chapter'
    assert_equal expected.v2, actual.v2, 'Second verse'
  end

  def assert_parsed_passage expected_passage, text
    res = @parser.parse(text)
    assert_array_size 1, res
    assert_equal_passage expected_passage, res.first
  end

end
