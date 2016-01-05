require 'ostruct'
require 'regtest'
require 'scripref'

include Regtest
include Scripref

o = OpenStruct.new
o.b1 = [42]
o.c1 = [1, nil]
o.v1 = [2, nil]
o.b2 = [43, nil]
o.c2 = [3, nil]
o.v2 = [4, nil]

formatter = Formatter.new(German)

combinations(o).each do |c|
  a = [c.b1, c.c1, c.v1, c.b2, c.c2, c.v2]
  pass = Passage.new('', *a)
  h = pass.to_h
  h.shift
  sample h do
    formatter.format([pass])
  end
end
