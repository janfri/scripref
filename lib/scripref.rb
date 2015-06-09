# - encoding: utf-8 -
require 'scripref/parser'
require 'scripref/processor'
require 'scripref/formatter'
require 'scripref/english'
require 'scripref/german'

module Scripref

  VERSION = '0.5.0'

  Passage = Struct.new(:text, :b1, :c1, :v1, :b2, :c2, :v2, :a1, :a2) do

    def initialize text, b1, c1, v1, b2, c2, v2, opts={}
      super text, b1, c1, v1, b2, c2, v2, opts[:a1], opts[:a2]
    end

    alias to_s text
  end

  # check if the book has only one chapter
  def self.book_has_only_one_chapter? book
    [31, 63, 64, 65].include?(book)
  end

end
