# encoding: utf-8
# frozen_string_literal: true

require 'delegate'

module Scripref

  VERSION = '1.2.0'

  require_relative 'scripref/bookname'
  require_relative 'scripref/bookorder'
  require_relative 'scripref/english'
  require_relative 'scripref/formatter'
  require_relative 'scripref/german'
  require_relative 'scripref/parser'
  require_relative 'scripref/passage'
  require_relative 'scripref/processor'

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
