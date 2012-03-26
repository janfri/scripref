# - encoding: utf-8 -
require 'strscan'
require 'scripref/parser'

module Scripref

  class Processor

    include Enumerable

    attr_accessor :text

    def initialize text, *mods
      @text = text
      @mods = mods
      mods.each do |m|
        extend m
      end
      @parser = Parser.new(*mods)
    end

    # Iterate over each parsed reference if block given, gets an iterator
    # over each parsed reference otherwise.
    def each_ref
      if block_given?
        scanner = StringScanner.new(text)
        while scanner.scan_until(reference_re)
          yield @parser.parse(scanner.matched)
        end
        self
      else
        enum_for :each_ref
      end
    end

  # Iterate over each piece of <tt>str</tt> (text and parsed references)
  # if block given, gets an iterator over the pieces otherwise.
  def each
    if block_given?
      scanner = StringScanner.new(text)
      while scanner.scan(/(.*?)(#{Regexp.new(reference_re.to_s)})/)
        yield scanner[1]
        yield @parser.parse(scanner[2])
      end
      yield scanner.rest if scanner.rest
      self
    else
      enum_for :each
    end
  end

  def inspect
    "#<#{self.class} #{@mods.inspect}>"
  end

end

end
