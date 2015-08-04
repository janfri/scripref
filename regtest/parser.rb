require 'regtest'
require 'scripref'

include Regtest
include Scripref

$parser = Parser.new(German)

def s text
  sample text do
    res = $parser.parse(text)
    res.map {|r| r.respond_to?(:to_h) ? r.to_h : r.to_s}
  end
end

s 'Ruth 2,1a-11.15a; 3,7b.9-12b; Markus 4; 5,3a.18b-21a'
