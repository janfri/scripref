require 'regtest'
require 'scripref'

include Scripref

def s text
  Regtest.sample text do
    p = Processor.new(text, German)
    p.each.to_a
  end
end

text = 'Ruth 2,1a-11.15a; 3,7b.9-12b; Markus 4; 5,3a.18b-21a'

s text

a = text.split(/\b/)
a.each_with_index do |e, i|
  next if e =~ /^\s+$/
  a2 = a.clone
  a2.delete_at(i)
  t = a2.join
  s t
end
