# encoding: utf-8
# frozen_string_literal: true

require_relative 'test_helper'

class TestIntegration < Test::Unit::TestCase

  include Scripref

  def setup
    @parser = Parser.new(German)
    @german_formatter = Formatter.new(German)
    @english_formatter = Formatter.new(English)
  end

  def test_only_book
    @german = 'Römer'
    @english = 'Romans'
    check_formatting
  end

  def test_book_and_chapter
    @german = 'Römer 8'
    @english = 'Romans 8'
    check_formatting
  end

  def test_one_verse
    @german = 'Römer 6,23'
    @english = 'Romans 6:23'
    check_formatting
  end

  def test_book_range
    @german = 'Römer-Hebräer'
    @english = 'Romans-Hebrews'
    check_formatting
  end

  def test_chapter_range
    @german = 'Römer 1-8'
    @english = 'Romans 1-8'
    check_formatting
  end

  def test_simple_passage
    @german = 'Römer 8,1-10'
    @english = 'Romans 8:1-10'
    check_formatting
  end

  def test_passage_with_chapter_change
    @german = 'Römer 1,1-5,11'
    @english = 'Romans 1:1-5:11'
    check_formatting
  end

  def test_passage_with_book_change
    @german = '1. Korinther 1,1-2. Korinther 13,13'
    @english = '1 Corinthians 1:1-2 Corinthians 13:13'
    check_formatting
  end

  def test_passage_with_different_chapter_and_same_verse
    @german = '2. Petrus 1,13-2,13'
    @english = '2 Peter 1:13-2:13'
    check_formatting
  end

  def test_book_with_only_one_chapter
    @german = 'Obadja 3'
    @english = 'Obadiah 3'
    check_formatting
  end

  def test_book_with_only_one_chapter_range
    @german = 'Obadja 3-5'
    @english = 'Obadiah 3-5'
    check_formatting
  end

  def test_book_with_only_one_chapter_at_end_of_range
    @german = 'Amos 2,4-Obadja 3'
    @english = 'Amos 2:4-Obadiah 3'
    check_formatting
  end

  def test_attr_writer_overrides_value_of_mixin
    @german = '1. Korinther 1,1 - 2. Korinther 13,13'
    @english = '1 Corinthians 1:1 - 2 Corinthians 13:13'
    @german_formatter.hyphen_separator = ' - '
    @english_formatter.hyphen_separator = ' - '
    check_formatting
  end

  def test_alternative_booknames
    ast = @parser.parse('Zephanja 1,8')
    assert_equal 'Zefanja 1,8', @german_formatter.format(ast)
  end

  def test_addon1
    @german = 'Markus 2,4b'
    @english = 'Mark 2:4b'
    check_formatting
  end

  def test_addon2
    @german = 'Markus 2,2-4b'
    @english = 'Mark 2:2-4b'
    check_formatting
  end

  def test_both_addons
    @german = 'Markus 2,2b-4a'
    @english = 'Mark 2:2b-4a'
    check_formatting
  end

  def test_postfix_one_following_verse
    @german = 'Markus 2,2f'
    @english = 'Mark 2:2f'
    check_formatting
  end

  def test_postfix_more_following_verses
    @german = 'Markus 2,2ff'
    @english = 'Mark 2:2ff'
    check_formatting
  end

  private

  def check_formatting
    ast = @parser.parse(@german)
    assert_equal @german, @german_formatter.format(ast)
    assert_equal @english, @english_formatter.format(ast)
  end

end
