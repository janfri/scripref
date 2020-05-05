# encoding: utf-8
# frozen_string_literal: true

module Scripref

  module Pipelining
    def >> o
      o << self
    end
  end

end

class Array
 include Scripref::Pipelining
end

class String
  include Scripref::Pipelining
end
