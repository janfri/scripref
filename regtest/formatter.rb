require 'ostruct'
require 'regtest'
require_relative '../lib/scripref'

include Scripref

o = OpenStruct.new
o.b1 = [:Luke]
o.c1 = [1, nil]
o.v1 = [2, nil]
o.b2 = [:John, nil]
o.c2 = [3, nil]
o.v2 = [4, nil]

formatter = Formatter.new(German)

Regtest.combinations(o).each do |c|
  pass = Passage.new(text: '', b1: c.b1, c1: c.c1, v1: c.v1, b2: c.b2, c2: c.c2, v2: c.v2)
  h = pass.to_h
  h.shift
  Regtest.sample h do
    formatter.format([pass])
  end
end
