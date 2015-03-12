# - encoding: utf-8 -
require 'test/unit'
require 'test_helper'
require 'scripref'
require 'scripref/pipelining'

class TestPipelining < Test::Unit::TestCase

  include Test::Helper
  include Scripref

  def test_right_to_left
    text = 'Hebräer 13,8'
    parser = Parser.new(German)
    formatter = Formatter.new(English)
    result = formatter << (parser << text)
    assert_equal 'Hebrews 13:8', result
  end

  using Pipelining

  def test_left_to_right
    text = 'Hebräer 13,8'
    parser = Parser.new(German)
    formatter = Formatter.new(English)
    result = text >> parser >> formatter
    assert_equal 'Hebrews 13:8', result
  end

end
