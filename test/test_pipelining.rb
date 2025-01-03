# encoding: utf-8
# frozen_string_literal: true

require_relative 'test_helper'

class TestPipelining < Test::Unit::TestCase

  include Scripref
  include Test::Helper

  def test_right_to_left
    text = 'Hebräer 13,8'
    parser = Parser.new(German)
    formatter = Formatter.new(English)
    result = formatter << (parser << text)
    assert_equal 'Hebrews 13:8', result
  end

  def test_left_to_right
    require_relative '../lib/scripref/pipelining'
    text = 'Hebräer 13,8'
    parser = Parser.new(German)
    formatter = Formatter.new(English)
    result = text >> parser >> formatter
    assert_equal 'Hebrews 13:8', result
  end

end
