# - encoding: utf-8 -
require 'test_helper'

class TestProcessorIterators < Test::Unit::TestCase

  include Scripref
  include Test::Helper

  def setup
    @text = 'Some text Mt 1,1 and Mr 2 and so on ...'
    @mt = [pass('Mt 1,1 ', 40, 1, 1, 40, 1, 1)]
    @mr = [pass('Mr 2 ', 41, 2, nil, 41, 2, nil)]
    @processor = Processor.new(@text, German)
    @chunks = ['Some text ', @mt, 'and ', @mr, 'and so on ...']
  end

  def test_each_with_block
    @processor.each do |chunk|
      assert_equal @chunks.shift, chunk
    end
  end

  def test_each_without_block
    enum = @processor.each
    assert_kind_of Enumerator, enum
    assert_equal @chunks, enum.to_a
  end

  def test_each_ref_with_block
    refs = @chunks.select {|c| c.kind_of? Array}
    @processor.each_ref do |ref|
      assert_equal refs.shift, ref
    end
  end

  def test_each_ref_without_block
    enum = @processor.each_ref
    refs = @chunks.select {|c| c.kind_of? Array}
    assert_kind_of Enumerator, enum
    assert_equal refs, enum.to_a
  end

end

class TestProcessorVariousContexts < Test::Unit::TestCase

  include Scripref
  include Test::Helper

  def test_reference_without_other_text
    text = 'Mt 1,1'
    ast = [[pass('Mt 1,1 ', 40, 1, 1, 40, 1, 1)]]
    processor = Processor.new(text, German)
    assert_equal ast, processor.each_ref.to_a
    assert_equal ast, processor.each.to_a
  end

  def test_text_without_reference
    text = 'some text'
    processor = Processor.new(text, German)
    assert_equal [], processor.each_ref.to_a
    assert_equal [text], processor.each.to_a
  end

  def test_empty_text
    text = ''
    processor = Processor.new(text, German)
    assert_equal [], processor.each_ref.to_a
    assert_equal [], processor.each.to_a
  end

  def test_numerical_context
    text = '1. Mt 1,1'
    processor = Processor.new(text, German)
    ast = [[pass(text, 40, 1, 1, 40, 1, 1)]]
    assert_equal ast, processor.each_ref.to_a
    ast = ['1. ', [pass(text, 40, 1, 1, 40, 1, 1)]]
    assert_equal ast, processor.each.to_a
  end

  def test_verse_addon_or_postfix
    text = 'Mt 1,1a'
    processor = Processor.new(text, German)
    ast = [[pass(text, 40, 1, 1, 40, 1, 1, a1: 'a')]]
    assert_equal ast, processor.each.to_a
    text = 'Mt 1,1f'
    processor = Processor.new(text, German)
    ast = [[pass(text, 40, 1, 1, 40, 1, :f)]]
    assert_equal ast, processor.each.to_a
    text = 'Mt 1,1ff'
    processor = Processor.new(text, German)
    ast = [[pass(text, 40, 1, 1, 40, 1, :ff)]]
    assert_equal ast, processor.each.to_a
  end

  def test_verse_addon_or_postfix_for_books_with_only_one_chapter
    text = '2. Joh 5b'
    processor = Processor.new(text, German)
    ast = [[pass(text, 63, 1, 5, 63, 1, 5, a1: 'b')]]
    assert_equal ast, processor.each.to_a
    text = '2. Joh 5f'
    processor = Processor.new(text, German)
    ast = [[pass(text, 63, 1, 5, 63, 1, :f)]]
    assert_equal ast, processor.each.to_a
    text = '2. Joh 5ff'
    processor = Processor.new(text, German)
    ast = [[pass(text, 63, 1, 5, 63, 1, :ff)]]
    assert_equal ast, processor.each.to_a
  end

  def test_verse_sep
    text = '2. Joh 5.8'
    processor = Processor.new(text, German)
    ast = [[pass(text, 63, 1, 5, 63, 1, 5), '.', pass(text, 63, 1, 8, 63, 1, 8)]]
    assert_equal ast, processor.each.to_a
  end

  def test_complex_reference
    prefix = 'Wie in den Stellen '
    ref = 'Apg 2,3; 4,8; 7,55; 8,29-39; Röm 8,2-9; Gal 6,8 '
    postfix = 'nachzulesen ...'
    text = prefix + ref + postfix
    processor = Processor.new(text, German)
    ast = [pass('Apg 2,3', 44, 2, 3, 44, 2, 3), '; ', pass('4,8', 44, 4, 8, 44, 4, 8), '; ',
            pass('7,55', 44, 7, 55, 44, 7, 55), '; ', pass('8,29-39', 44, 8, 29, 44, 8, 39), '; ',
            pass('Röm 8,2-9', 45, 8, 2, 45, 8, 9), '; ', pass('Gal 6,8 ', 48, 6, 8, 48, 6, 8)]
    assert_equal [ast], processor.each_ref.to_a
    assert_equal [prefix, ast, postfix], processor.each.to_a
  end

  def test_reference_ends_with_chapter_or_verse
    text = 'Joh 8.'
    processor = Processor.new(text, German)
    ast = [pass('Joh 8', 43, 8, nil, 43, 8, nil)]
    assert_equal [ast], processor.each_ref.to_a
    assert_equal [ast, '.'], processor.each.to_a
    text = 'Joh 8,12.'
    processor = Processor.new(text, German)
    ast = [pass('Joh 8,12', 43, 8, 12, 43, 8, 12)]
    assert_equal [ast], processor.each_ref.to_a
    assert_equal [ast, '.'], processor.each.to_a
  end

end
