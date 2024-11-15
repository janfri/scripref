# encoding: utf-8
# frozen_string_literal: true

require 'delegate'

module Scripref

  VERSION = '1.1.0'

  autoload :Bookname, 'scripref/bookname'
  autoload :Bookorder, 'scripref/bookorder'
  autoload :English, 'scripref/english'
  autoload :Formatter, 'scripref/formatter'
  autoload :German, 'scripref/german'
  autoload :Parser, 'scripref/parser'
  autoload :Passage, 'scripref/passage'
  autoload :Processor, 'scripref/processor'

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
