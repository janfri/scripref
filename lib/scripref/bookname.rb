# encoding: utf-8
# frozen_string_literal: true

module Scripref

  class Bookname

    attr_reader :osis_id, :names, :abbrevs

    def initialize osis_id:, names:, abbrevs:
      @osis_id = osis_id
      @names = Array(names)
      @abbrevs = Array(abbrevs)
    end

    def name
      @names.first
    end

    def abbrev level=0
      @abbrevs[level] || @abbrevs[-1]
    end

    def to_s
      @osis_id.to_s
    end

    alias to_str to_s

  end

end
