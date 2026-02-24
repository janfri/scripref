# encoding: utf-8
# frozen_string_literal: true

require_relative 'test_helper'

class TestBookname < Test::Unit::TestCase

  include Scripref

  def setup
    @zef = Bookname.new(osis_id: :Zeph, names: %w(Zefanja Zefan Zef), alt_names: %w(Zephanja Zeph))
  end

  def test_name
    assert_equal 'Zefanja', @zef.name
  end

end
