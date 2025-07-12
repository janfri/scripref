# encoding: utf-8
require_relative 'lib/scripref'

Gem::Specification.new do |s|
  s.name = 'scripref'
  s.summary = 'Library for parsing scripture references in real texts.'
  s.version = Scripref::VERSION
  s.authors = 'Jan Friedrich'
  s.email = 'janfri26@gmail.com'
  s.license = 'MIT'

  s.homepage = 'https://github.com/janfri/scripref'
  s.metadata = {
    'homepage_uri' => s.homepage,
    'source_code_uri' => s.homepage
  }

  s.require_paths = 'lib'
  s.files = %w[Changelog LICENSE README.md Rakefile scripref.gemspec] + Dir['lib/**/*'] + Dir['regtest/**/*'] + Dir['test/**.*']

  s.add_development_dependency('rake', '>= 0')
  s.add_development_dependency('rim', '~> 3.0')
  s.add_development_dependency('regtest', '~> 2')
  s.add_development_dependency('test-unit', '~> 3.7')
end
