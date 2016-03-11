# - encoding: utf-8 -
require 'delegate'
require 'scripref/parser'
require 'scripref/passage'
require 'scripref/processor'
require 'scripref/formatter'
require 'scripref/english'
require 'scripref/german'

module Scripref

  VERSION = '0.9.1'

  class Sep < DelegateClass(String)
    def initialize s
      super s
    end
  end

  class PassSep < Sep; end

  class VerseSep < Sep; end

end
