# - encoding: utf-8 -
require 'test/unit'
require 'scripref'

class TestProcessor < Test::Unit::TestCase

  def setup
    @text = 'Some text Mt 1,1 and Mr 2 and so on ...'
    @mt = [Scripref::Passage.new('Mt 1,1 ', 40, 1, 1, 40, 1, 1)]
    @mr = [Scripref::Passage.new('Mr 2 ', 41, 2, 1, 41, 2, :max)]
    @processor = Scripref::Processor.new(@text, Scripref::German)
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
