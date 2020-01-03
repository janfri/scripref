require 'rim/tire'
require 'rim/regtest'
require 'rim/version'

$:.unshift File.dirname(__FILE__) + '/lib'
require 'scripref'

Rim.setup do
  name 'scripref'
  authors 'Jan Friedrich'
  email 'janfri26@gmail.com'
  homepage 'https://github.com/janfri/scripref'
  version Scripref::VERSION
  summary 'Library for parsing scripture references in real texts.'
  if feature_loaded? 'rim/irb'
    irb_requires %w(scripref scripref/include scripref/pipelining)
  end
  ruby_version '>=2.5.0'
  test_warning false
end
