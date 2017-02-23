# - encoding: utf-8 -
require 'strscan'
require 'scripref/basic_methods'
require 'scripref/parser'

module Scripref

  class Processor

    include Enumerable
    include BasicMethods

    attr_accessor :text

    # @param text text to parse
    # @param mods one or more modules to include in processor and parser
    def initialize text=nil, *mods
      @text = text
      @mods = mods
      mods.each {|m| extend m}
      @parser = Parser.new(*mods)
    end

    # Iterate over each parsed reference if block given, gets an iterator
    # over each parsed reference otherwise.
    def each_ref
      if block_given?
        scanner = StringScanner.new(text)
        while scanner.scan_until(reference_re)
          begin
            yield @parser.parse(scanner.matched)
          rescue ParserError
          end
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
        while scanner.scan(/(.*?)(#{reference_re.source})/)
          yield scanner[1] unless scanner[1].empty?
          begin
            yield @parser.parse(scanner[2])
          rescue ParserError
            yield scanner[2]
          end
        end
        yield scanner.rest if scanner.rest?
        self
      else
        enum_for :each
      end
    end

    def inspect
      "#<#{self.class} #{@mods.inspect}>"
    end

#    private

    # Regular expression to heuristically identify a reference
    def reference_re
      return @reference_re if @reference_re
      verse_with_optional_addon_or_postfix = '(' << [postfix_one_following_verse_re, postfix_more_following_verses_re, verse_addon_re].map {|e| verse_re.source << e.source}.join(')|(') << ')'
      re_parts = [
        '(', book_re, ')', '((', verse_with_optional_addon_or_postfix, ')|(', chapter_re, ')|(', verse_re, '))',
        '(',
        '(', book_re, ')',
        '|',
        verse_with_optional_addon_or_postfix,
        '|',
        '(', [chapter_re, cv_sep_re, verse_re, verse_sep_re, hyphen_re, pass_sep_re].map(&:source).join(')|('), ')',
        ')*'
      ].map {|e| Regexp === e ? e.source : e}
      @reference_re = Regexp.compile(re_parts.join, nil)
    end

  end

end
