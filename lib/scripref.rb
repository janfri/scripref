# - encoding: utf-8 -
require 'delegate'
require 'scripref/bookname'
require 'scripref/parser'
require 'scripref/passage'
require 'scripref/processor'
require 'scripref/formatter'
require 'scripref/english'
require 'scripref/german'

module Scripref

  VERSION = '0.10.0'

  class Token < DelegateClass(String)
    def initialize *args
      super
    end
  end

  class Book < Token; end
  class Chapter < Token; end
  class Verse < Token; end

  class Addon < Token; end
  class Postfix < Token; end

  class Sep < Token; end
  class PassSep < Sep; end
  class VerseSep < Sep; end

  class Space < Token; end

end
