# - encoding: utf-8 -
require 'test/unit'
require 'test_helper'
require 'scripref'
require 'scripref/english'
require 'scripref/formatter'
require 'scripref/german'
require 'scripref/parser'

class TestFormatter < Test::Unit::TestCase

  include Test::Helper

  def setup
    @parser = Scripref::Parser.new(Scripref::German)
    @german_formatter = Scripref::Formatter.new(Scripref::German)
    @english_formatter = Scripref::Formatter.new(Scripref::English)
  end

  def test_one_verse
    @german = 'Römer 6,23'
    @english = 'Romans 6:23'
    assert_formatting
  end

  def test_simple_passage
    @german = 'Römer 8,1-10'
    @english = 'Romans 8:1-10'
    assert_formatting
  end

  def test_passage_with_chapter_change
    @german = 'Römer 1,1-5,11'
    @english = 'Romans 1:1-5:11'
    assert_formatting
  end

  def test_passage_with_book_change
    @german = '1. Korinther 1,1-2. Korinther 13,13'
    @english = '1 Corinthians 1:1-2 Corinthians 13:13'
    assert_formatting
  end

  private

  def assert_formatting
    ast = @parser.parse(@german)
    assert_equal @german, @german_formatter.fullref(ast)
    assert_equal @english, @english_formatter.fullref(ast)
  end

end