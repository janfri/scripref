# - encoding: utf-8 -
require 'strscan'
require 'scripref/parser'

module Scripref

  class Processor

    def initialize mod
      extend mod
      @parser = Parser.new(mod)
    end

    # Callback to handle normal text (no reference).
    def text &blk
      @text = blk
    end

    # Callback to handle references.
    def ref &blk
      @ref = blk
    end

    # Process <tt>str</tt> and execute the callbac(s) if given.
    def process str
      each str do |e|
        if @text && e.kind_of?(String)
          @text.call e
        end
        if @ref && e.kind_of?(Array)
          @ref.call e
        end
      end
      self
    end

    # Iterate over each parsed reference if block given, gets an iterator
    # over each parsed reference otherwise.
    def each_ref str
      enum = Enumerator.new do |y|
        scanner = StringScanner.new(str)
        while scanner.scan_until(reference_re)
          y << @parser.parse(scanner.matched)
        end
      end
      if block_given?
        enum.each do |e|
          yield e
        end
      end
      enum
    end


    # Iterate over each piece of <tt>str</tt> (text and parsed references)
    # if block given, gets an iterator over the pieces otherwise.
    def each str
      enum = Enumerator.new do |y|
        scanner = StringScanner.new(str)
        while scanner.scan(/(.*?)(#{Regexp.new(reference_re.to_s)})/)
          y << scanner[1]
          y << @parser.parse(scanner[2])
        end
        y << scanner.rest if scanner.rest
      end
      if block_given?
        enum.each do |e|
          yield e
        end
      end
      enum
    end


  end

end
