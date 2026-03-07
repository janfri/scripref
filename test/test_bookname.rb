# encoding: utf-8
# frozen_string_literal: true

require_relative 'test_helper'

class TestBookname < Test::Unit::TestCase

  include Scripref

  def setup
    @zef = Bookname.new(osis_id: :Zeph, name: 'Zefanja', abbrevs: %w(Zefan Zef), alternatives: Bookname.new(osis_id: :Zeph, name: 'Zephanja', abbrevs: 'Zeph'))
  end

  def test_each_name
    assert_equal %w(Zefanja Zephanja), @zef.each_name.to_a
  end

  def test_each_string
    assert_equal %w(Zefanja Zefan Zef Zephanja Zeph), @zef.each_string.to_a
  end

end
