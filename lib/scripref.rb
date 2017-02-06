# - encoding: utf-8 -
require 'delegate'

module Scripref

  VERSION = '0.12.0'

  autoload :Bookname, 'scripref/bookname'
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
