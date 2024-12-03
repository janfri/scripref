# encoding: utf-8
# frozen_string_literal: true

require_relative '../lib/scripref'
require 'test/unit'

module Test::Helper

  def pass **kwargs
    Scripref::Passage.new(**kwargs)
  end

  def semi
    Scripref::PassSep.new('; ')
  end

  def dot
    Scripref::VerseSep.new('.')
  end

end
