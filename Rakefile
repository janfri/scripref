require 'rim/tire'
require 'rim/regtest'
require 'rim/version'

Rim.setup do
  if feature_loaded? 'rim/irb'
    irb_requires %w(scripref scripref/include scripref/pipelining)
  end
  test_warning false
end
