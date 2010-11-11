require 'test/unit'
require 'scripref'

class Test::Unit::TestCase

  def assert_equal_passage expexted, actual
    assert_equal expexted.text, actual.text
    assert_equal expexted.b1, actual.b1
    assert_equal expexted.c1, actual.c1
    assert_equal expexted.v1, actual.v1
    assert_equal expexted.b2, actual.b2
    assert_equal expexted.c2, actual.c2
    assert_equal expexted.v2, actual.v2
  end

end
