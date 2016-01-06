# -*- encoding: utf-8 -*-
# stub: scripref 0.7.0 ruby lib
#
# This file is automatic generated by rim.
# PLEASE DO NOT EDIT IT DIRECTLY!
# Change instead the values in Rim.setup in Rakefile.

Gem::Specification.new do |s|
  s.name = "scripref"
  s.version = "0.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jan Friedrich"]
  s.date = "2016-01-06"
  s.description = ""
  s.files = ["CHANGELOG", "LICENSE", "README.md", "Rakefile", "lib/scripref", "lib/scripref.rb", "lib/scripref/const_reader.rb", "lib/scripref/english.rb", "lib/scripref/formatter.rb", "lib/scripref/german.rb", "lib/scripref/parser.rb", "lib/scripref/pipelining.rb", "lib/scripref/processor.rb", "regtest/formatter.rb", "regtest/formatter.yml", "regtest/parser.rb", "regtest/parser.yml", "test/test_english.rb", "test/test_formatter.rb", "test/test_german.rb", "test/test_helper.rb", "test/test_parser.rb", "test/test_passage.rb", "test/test_pipelining.rb", "test/test_processor.rb"]
  s.homepage = "https://github.com/janfri/scripref"
  s.rubygems_version = "2.5.1"
  s.summary = "Library for parsing scripture references in real texts."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rim>, ["~> 2.6"])
      s.add_development_dependency(%q<regtest>, ["~> 0.4"])
    else
      s.add_dependency(%q<rim>, ["~> 2.6"])
      s.add_dependency(%q<regtest>, ["~> 0.4"])
    end
  else
    s.add_dependency(%q<rim>, ["~> 2.6"])
    s.add_dependency(%q<regtest>, ["~> 0.4"])
  end
end
