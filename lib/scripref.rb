# - encoding: utf-8 -
require 'scripref/parser'
require 'scripref/processor'
require 'scripref/english'
require 'scripref/german'

module Scripref

  VERSION = '0.1.0'

  Passage = Struct.new(:text, :b1, :c1, :v1, :b2, :c2, :v2)

  class Passage
    alias to_s text
  end

end
