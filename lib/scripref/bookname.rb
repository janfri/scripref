# encoding: utf-8
# frozen_string_literal: true

module Scripref

  class Bookname

    attr_reader :book_id

    # @param book_id OSID-ID of the book
    # @param name full name of the book
    # @param abbrevs possible abbreviations for the book
    # @param alternatives further Bookname instances with alternative names and abbreviations for book
    def initialize book_id:, name:, abbrevs: [], alternatives: []
      @book_id = book_id
      @name = name
      @abbrevs = Array(abbrevs)
      @alternatives = Array(alternatives)
    end

    # Format the bookname (full name or abbreviation)
    # @param abbrev_level if 0 full name, if >0 an abbreviation
    def format abbrev_level: 0
      case
      when abbrev_level == 0
        @name
      when abbrev_level > 0
        @abbrevs[abbrev_level - 1] || @abbrevs[-1] || @name
      else
        fail ArgumentError, 'negative values for abbrev_level are not allowed'
      end
    end

    # Enumerator over all names (name and name of alternatives)
    def each_name
      if block_given?
        yield @name
        @alternatives.each do |bn|
          bn.each_name do |alt_name|
            yield alt_name
          end
        end
      else
        enum_for :each_name
      end
    end

    # Enumerator over all names and abbreviations (including alternatives)
    def each_string
      if block_given?
        yield @name
        @abbrevs.each do |a|
          yield a
        end
        @alternatives.each do |bn|
          bn.each_string do |s|
            yield s
          end
        end
      else
        enum_for :each_string
      end
    end

    def to_s
      @name
    end

    # Convert the instance to an equivalent string representation
    def dump
      s = Kernel.format('%s: %s', @book_id, [@name, @abbrevs].flatten.join('|'))
      [s, @alternatives.map(&:dump).map {|s| s.sub(/^.+?: /, '')}].flatten.join(', ')
    end

    def inspect
      Kernel.format('#<%s %s>', self.class, dump.inspect)
    end

    alias to_str to_s

    class << self

      # Helper method to create Bookname instances from a String
      # @param s string to parse
      # format: [book_id]: [full name]|[abbrev1]|[abbrev2]|...(, [alternative name]|[abbrev1],...]*
      # @example Format
      #   Zeph: Zefanja|Zef, Zephanja|Zeph
      # @example Code equivalent
      #   Bookname.new(book_id: :Zeph, name: 'Zefanja', abbrevs: ['Zef'], alternatives: Bookname.new(book_id: :Zeph, name: 'Zephanja', abbrevs: ['Zeph']))
      def parse s
        book_id, rest = s.split(/:\s*/).map(&:strip)
        book_id = book_id.to_sym
        org, *alternatives = rest.split(/,\s*/).map(&:strip)
        name, *abbrevs = org.split('|').map(&:strip)
        alternatives.map! do |s|
          n, *a = s.split('|').map(&:strip)
          Bookname.new(book_id: book_id, name: n, abbrevs: a)
        end
        Bookname.new(book_id: book_id, name: name, abbrevs: abbrevs, alternatives: alternatives)
      end

    end

  end

end
