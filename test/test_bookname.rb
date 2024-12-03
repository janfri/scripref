# encoding: utf-8
# frozen_string_literal: true

require_relative 'test_helper'

class TestBookname < Test::Unit::TestCase

  include Scripref

  def setup
    @zef = Bookname.new(osis_id: :Zeph, names: %w(Zefanja Zephanja), abbrevs: %w(Zef Zefan Zeph Zephan))
  end

  def test_name
    assert_equal 'Zefanja', @zef.name
  end

  def test_abbrev
    assert_equal 'Zef', @zef.abbrev
  end

end
