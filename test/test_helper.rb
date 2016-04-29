# - encoding: utf-8 -
require 'scripref'
require 'test/unit'

module Test::Helper

  def pass *args
    Scripref::Passage.new(*args)
  end

  def semi
    Scripref::PassSep.new('; ')
  end

  def dot
    Scripref::VerseSep.new('.')
  end

end
