module Test::Helper

  def pass *args
    Scripref::Passage.new(*args)
  end

  def assert_equal_passage expected, actual
    assert_equal expected.text, actual.text, 'Parsed text'
    assert_equal expected.b1, actual.b1, 'First book'
    assert_equal expected.c1, actual.c1, 'First chapter'
    assert_equal expected.v1, actual.v1, 'First verse'
    assert_equal expected.b2, actual.b2, 'Second book'
    assert_equal expected.c2, actual.c2, 'Second chapter'
    assert_equal expected.v2, actual.v2, 'Second verse'
  end

  def assert_parsed_ast_for_text expected_ast, text
    res = @parser.parse(text)
    assert_equal expected_ast.size, res.size, 'Array size of AST'
    expected_ast.zip(res) do |expected_elem, actual_elem|
      if !expected_elem.kind_of?(String)
        assert_equal_passage expected_elem, actual_elem
      else
        assert_equal expected_elem, actual_elem
      end
    end
  end

end
