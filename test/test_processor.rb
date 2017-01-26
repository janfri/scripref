# - encoding: utf-8 -
require 'test_helper'

class TestProcessor < Test::Unit::TestCase

  include Scripref
  include Test::Helper

  def setup1
    @text = 'Some text Mt 1,1 and Mr 2 and so on ...'
    @mt = [pass('Mt 1,1 ', 40, 1, 1, 40, 1, 1)]
    @mr = [pass('Mr 2 ', 41, 2, nil, 41, 2, nil)]
    @processor = Processor.new(@text, German)
    @chunks = ['Some text ', @mt, 'and ', @mr, 'and so on ...']
  end

  def test_each_with_block
    setup1
    @processor.each do |chunk|
      assert_equal @chunks.shift, chunk
    end
  end

  def test_each_without_block
    setup1
    enum = @processor.each
    assert_kind_of Enumerator, enum
    assert_equal @chunks, enum.to_a
  end

  def test_each_ref_with_block
    setup1
    refs = @chunks.select {|c| c.kind_of? Array}
    @processor.each_ref do |ref|
      assert_equal refs.shift, ref
    end
  end

  def test_each_ref_without_block
    setup1
    enum = @processor.each_ref
    refs = @chunks.select {|c| c.kind_of? Array}
    assert_kind_of Enumerator, enum
    assert_equal refs, enum.to_a
  end

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

  def test_verse_addon
    text = 'Mt 1,1a'
    processor = Processor.new(text, German)
    ast = [[pass(text, 40, 1, 1, 40, 1, 1, a1: 'a')]]
    assert_equal ast, processor.each.to_a
  end

  def test_verse_postfixes
    text = 'Mt 1,1f'
    processor = Processor.new(text, German)
    ast = [[pass(text, 40, 1, 1, 40, 1, :f)]]
    assert_equal ast, processor.each.to_a
    text = 'Mt 1,1ff'
    processor = Processor.new(text, German)
    ast = [[pass(text, 40, 1, 1, 40, 1, :ff)]]
    assert_equal ast, processor.each.to_a
  end

end
