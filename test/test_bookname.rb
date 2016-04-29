# - encoding: utf-8 -
require 'test/unit'
require 'scripref/bookname'

class TestBookname < Test::Unit::TestCase

  def setup
    @zef = Scripref::Bookname.new(%w(Zefanja Zephanja), %w(Zef Zefan Zeph Zephan))
  end

  def test_name
    assert_equal 'Zefanja', @zef.name
  end

  def test_abbrev
    assert_equal 'Zef', @zef.abbrev
  end

end
