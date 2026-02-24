# encoding: utf-8
# frozen_string_literal: true

module Scripref

  class Bookname

    attr_reader :osis_id, :names, :alt_names

    def initialize osis_id:, names:, alt_names: []
      @osis_id = osis_id
      @names = Array(names)
      @alt_names = Array(alt_names)
    end

    def name abbrev_level: 0
      @names[abbrev_level] || @names[-1]
    end

    def to_s
      name
    end

    alias to_str to_s

  end

end
