# - encoding: utf-8 -
require 'scripref/parser'
require 'scripref/german'

module Scripref
  
  Passage = Struct.new(:text, :b1, :c1, :v1, :b2, :c2, :v2)

  class Passage
    alias to_s text
  end

end
