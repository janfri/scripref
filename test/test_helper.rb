# - encoding: utf-8 -
require 'scripref'
require 'test/unit'

module Test::Helper

  def pass *args, **kwargs
    text, b1, c1, v1, b2, c2, v2 = args
    a1 = kwargs[:a1]
    a2 = kwargs[:a2]
    Scripref::Passage.new(text: text, b1: b1, c1: c1, v1: v1, b2: b2, c2: c2, v2: v2, a1: a1, a2: a2)
  end

  def semi
    Scripref::PassSep.new('; ')
  end

  def dot
    Scripref::VerseSep.new('.')
  end

end
