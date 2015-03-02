# - encoding: utf-8 -
require 'scripref/parser'
require 'scripref/processor'
require 'scripref/formatter'
require 'scripref/english'
require 'scripref/german'

module Scripref

  VERSION = '0.2.0'

  Passage = Struct.new(:text, :b1, :c1, :v1, :b2, :c2, :v2, :a1, :a2) do

    def initialize text, b1, c1, v1, b2, c2, v2, opts={}
      super text, b1, c1, v1, b2, c2, v2, opts[:a1], opts[:a2]
    end

    alias to_s text
  end

end
