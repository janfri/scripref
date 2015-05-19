# - encoding: utf-8 -

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
