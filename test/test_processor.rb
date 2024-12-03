# encoding: utf-8
# frozen_string_literal: true

require_relative 'test_helper'

class TestProcessorIterators < Test::Unit::TestCase

  include Scripref
  include Test::Helper

  def setup
    @text = 'Some text Mt 1,1 and Mr 2 and so on ...'
    @mt = [pass(text: 'Mt 1,1 ', b1: :Matt, c1: 1, v1: 1, b2: :Matt, c2: 1, v2: 1)]
    @mr = [pass(text: 'Mr 2 ', b1: :Mark, c1: 2, b2: :Mark, c2: 2)]
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
    ast = [[pass(text: 'Mt 1,1 ', b1: :Matt, c1: 1, v1: 1, b2: :Matt, c2: 1, v2: 1)]]
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
    ast = [[pass(text: text, b1: :Matt, c1: 1, v1: 1, b2: :Matt, c2: 1, v2: 1)]]
    assert_equal ast, processor.each_ref.to_a
    ast = ['1. ', [pass(text: text, b1: :Matt, c1: 1, v1: 1, b2: :Matt, c2: 1, v2: 1)]]
    assert_equal ast, processor.each.to_a
  end

  def test_verse_addon_or_postfix
    text = 'Mt 1,1a'
    processor = Processor.new(text, German)
    ast = [[pass(text: text, b1: :Matt, c1: 1, v1: 1, b2: :Matt, c2: 1, v2: 1, a1: 'a')]]
    assert_equal ast, processor.each.to_a
    text = 'Mt 1,1f'
    processor = Processor.new(text, German)
    ast = [[pass(text: text, b1: :Matt, c1: 1, v1: 1, b2: :Matt, c2: 1, v2: :f)]]
    assert_equal ast, processor.each.to_a
    text = 'Mt 1,1ff'
    processor = Processor.new(text, German)
    ast = [[pass(text: text, b1: :Matt, c1: 1, v1: 1, b2: :Matt, c2: 1, v2: :ff)]]
    assert_equal ast, processor.each.to_a
  end

  def test_verse_addon_or_postfix_for_books_with_only_one_chapter
    text = '2. Joh 5b'
    processor = Processor.new(text, German)
    ast = [[pass(text: text, b1: :'2John', c1: 1, v1: 5, b2: :'2John', c2: 1, v2: 5, a1: 'b')]]
    assert_equal ast, processor.each.to_a
    text = '2. Joh 5f'
    processor = Processor.new(text, German)
    ast = [[pass(text: text, b1: :'2John', c1: 1, v1: 5, b2: :'2John', c2: 1, v2: :f)]]
    assert_equal ast, processor.each.to_a
    text = '2. Joh 5ff'
    processor = Processor.new(text, German)
    ast = [[pass(text: text, b1: :'2John', c1: 1, v1: 5, b2: :'2John', c2: 1, v2: :ff)]]
    assert_equal ast, processor.each.to_a
  end

  def test_verse_sep
    text = '2. Joh 5.8'
    processor = Processor.new(text, German)
    ast = [[pass(text: text, b1: :'2John', c1: 1, v1: 5, b2: :'2John', c2: 1, v2: 5), '.', pass(text: text, b1: :'2John', c1: 1, v1: 8, b2: :'2John', c2: 1, v2: 8)]]
    assert_equal ast, processor.each.to_a
  end

  def test_complex_reference
    prefix = 'Wie in den Stellen '
    ref = 'Apg 2,3; 4,8; 7,55; 8,29-39; Röm 8,2-9; Gal 6,8 '
    postfix = 'nachzulesen ...'
    text = prefix + ref + postfix
    processor = Processor.new(text, German)
    ast = [pass(text: 'Apg 2,3', b1: :Acts, c1: 2, v1: 3, b2: :Acts, c2: 2, v2: 3), '; ', pass(text: '4,8', b1: :Acts, c1: 4, v1: 8, b2: :Acts, c2: 4, v2: 8), '; ',
            pass(text: '7,55', b1: :Acts, c1: 7, v1: 55, b2: :Acts, c2: 7, v2: 55), '; ', pass(text: '8,29-39', b1: :Acts, c1: 8, v1: 29, b2: :Acts, c2: 8, v2: 39), '; ',
            pass(text: 'Röm 8,2-9', b1: :Rom, c1: 8, v1: 2, b2: :Rom, c2: 8, v2: 9), '; ', pass(text: 'Gal 6,8 ', b1: :Gal, c1: 6, v1: 8, b2: :Gal, c2: 6, v2: 8)]
    assert_equal [ast], processor.each_ref.to_a
    assert_equal [prefix, ast, postfix], processor.each.to_a
  end

  def test_reference_ends_with_chapter_or_verse
    text = 'Joh 8.'
    processor = Processor.new(text, German)
    ast = [pass(text: 'Joh 8', b1: :John, c1: 8, b2: :John, c2: 8)]
    assert_equal [ast], processor.each_ref.to_a
    assert_equal [ast, '.'], processor.each.to_a
    text = 'Joh 8,12.'
    processor = Processor.new(text, German)
    ast = [pass(text: 'Joh 8,12', b1: :John, c1: 8, v1: 12, b2: :John, c2: 8, v2: 12)]
    assert_equal [ast], processor.each_ref.to_a
    assert_equal [ast, '.'], processor.each.to_a
  end

end
