# encoding: utf-8
# frozen_string_literal: true

module Scripref

  class Bookname

    attr_reader :osis_id

    # @param osis_id: OSID-ID of book
    # @param name: full name of the book
    # @param abbrevs: possible abbreviations
    # @param alternatives: further Bookname instances with alternative names and abbreviations
    def initialize osis_id:, name:, abbrevs: [], alternatives: []
      @osis_id = osis_id
      @name = name
      @abbrevs = Array(abbrevs)
      @alternatives = Array(alternatives)
    end

    # Format the bookname (full name or abbreviation)
    # @param abbrev_level if 0: full name, if >0 an abbreviation
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

    alias to_str to_s

    class << self

      def parse_line l
        osis_id, rest = l.split(/:\s*/).map(&:strip)
        osis_id = osis_id.to_sym
        org, *alternatives = rest.split(/,\s*/).map(&:strip)
        name, *abbrevs = org.split('|').map(&:strip)
        alternatives.map! do |s|
          n, *a = s.split('|').map(&:strip)
          Bookname.new(osis_id: osis_id, name: n, abbrevs: a)
        end
        Bookname.new(osis_id: osis_id, name: name, abbrevs: abbrevs, alternatives: alternatives)
      end

    end

  end

end
