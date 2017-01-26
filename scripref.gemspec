# -*- encoding: utf-8 -*-
# stub: scripref 0.11.0 ruby lib
#
# This file is automatically generated by rim.
# PLEASE DO NOT EDIT IT DIRECTLY!
# Change instead the values in Rim.setup in Rakefile.

Gem::Specification.new do |s|
  s.name = "scripref".freeze
  s.version = "0.11.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jan Friedrich".freeze]
  s.date = "2017-01-26"
  s.description = "".freeze
  s.email = "janfri26@gmail.com".freeze
  s.files = ["Changelog".freeze, "LICENSE".freeze, "README.md".freeze, "Rakefile".freeze, "lib/scripref".freeze, "lib/scripref.rb".freeze, "lib/scripref/basic_methods.rb".freeze, "lib/scripref/bookname.rb".freeze, "lib/scripref/const_reader.rb".freeze, "lib/scripref/english.rb".freeze, "lib/scripref/formatter.rb".freeze, "lib/scripref/german.rb".freeze, "lib/scripref/include.rb".freeze, "lib/scripref/parser.rb".freeze, "lib/scripref/passage.rb".freeze, "lib/scripref/pipelining.rb".freeze, "lib/scripref/processor.rb".freeze, "regtest/formatter.rb".freeze, "regtest/formatter.yml".freeze, "regtest/parser.rb".freeze, "regtest/parser.yml".freeze, "regtest/processor.rb".freeze, "regtest/processor.yml".freeze, "test/test_bookname.rb".freeze, "test/test_english.rb".freeze, "test/test_formatter.rb".freeze, "test/test_german.rb".freeze, "test/test_helper.rb".freeze, "test/test_integration.rb".freeze, "test/test_parser.rb".freeze, "test/test_passage.rb".freeze, "test/test_pipelining.rb".freeze, "test/test_processor.rb".freeze]
  s.homepage = "https://github.com/janfri/scripref".freeze
  s.rubygems_version = "2.6.10".freeze
  s.summary = "Library for parsing scripture references in real texts.".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rim>.freeze, ["~> 2.9"])
      s.add_development_dependency(%q<regtest>.freeze, ["~> 0.4"])
    else
      s.add_dependency(%q<rim>.freeze, ["~> 2.9"])
      s.add_dependency(%q<regtest>.freeze, ["~> 0.4"])
    end
  else
    s.add_dependency(%q<rim>.freeze, ["~> 2.9"])
    s.add_dependency(%q<regtest>.freeze, ["~> 0.4"])
  end
end
