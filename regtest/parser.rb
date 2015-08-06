require 'regtest'
require 'scripref'

include Regtest
include Scripref

def s text
  sample text do
    res = Parser.new(German).parse(text)
    res.map {|r| r.respond_to?(:to_h) ? r.to_h : r.to_s}
  end
end

text = 'Ruth 2,1a-11.15a; 3,7b.9-12b; Markus 4; 5,3a.18b-21a'

s text

a = text.split(/\b/)
a.each do |e|
  next if e =~ /^\s+$/
  a2 = a.clone
  a2.delete(e)
  t = a2.join
  s t
end
