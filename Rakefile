require 'rim/tire'
require 'rim/regtest'
require 'rim/version'

Rim.setup do
  if feature_loaded? 'rim/irb'
    irb_requires %w(scripref scripref/include scripref/pipelining)
    if File.exist?(fn = './.irb_init.rb')
      irb_requires << fn
    end
  end
  test_warning false
end

task :default => :regtest
