# -*- encoding: utf-8 -*-
# stub: scripref 1.0.0 ruby lib
#
# This file is automatically generated by rim.
# PLEASE DO NOT EDIT IT DIRECTLY!
# Change the values in Rim.setup in Rakefile instead.

Gem::Specification.new do |s|
  s.name = "scripref"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jan Friedrich"]
  s.date = "2020-05-22"
  s.description = ""
  s.email = "janfri26@gmail.com"
  s.files = ["./.aspell.pws", "Changelog", "LICENSE", "README.md", "Rakefile", "lib/scripref", "lib/scripref.rb", "lib/scripref/basic_methods.rb", "lib/scripref/bookname.rb", "lib/scripref/bookorder.rb", "lib/scripref/const_reader.rb", "lib/scripref/english.rb", "lib/scripref/formatter.rb", "lib/scripref/german.rb", "lib/scripref/include.rb", "lib/scripref/parser.rb", "lib/scripref/passage.rb", "lib/scripref/pipelining.rb", "lib/scripref/processor.rb", "regtest/formatter.rb", "regtest/formatter.yml", "regtest/parser.rb", "regtest/parser.yml", "regtest/processor.rb", "regtest/processor.yml", "scripref.gemspec", "test/test_bookname.rb", "test/test_english.rb", "test/test_formatter.rb", "test/test_german.rb", "test/test_helper.rb", "test/test_integration.rb", "test/test_parser.rb", "test/test_passage.rb", "test/test_pipelining.rb", "test/test_processor.rb"]
  s.homepage = "https://github.com/janfri/scripref"
  s.required_ruby_version = Gem::Requirement.new(">= 2.5.0")
  s.rubygems_version = "3.1.2"
  s.summary = "Library for parsing scripture references in real texts."

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<rake>, [">= 0"])
    s.add_development_dependency(%q<rim>, ["~> 2.17"])
    s.add_development_dependency(%q<regtest>, ["~> 2"])
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rim>, ["~> 2.17"])
    s.add_dependency(%q<regtest>, ["~> 2"])
  end
end
