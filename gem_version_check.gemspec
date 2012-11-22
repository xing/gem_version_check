# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gem_version_check/version"

Gem::Specification.new do |s|
  s.name        = "gem_version_check"
  s.version     = GemVersionCheck::VERSION
  s.authors     = ["Frederik Dietz"]
  s.email       = ["fdietz@github.com"]
  s.homepage    = ""
  s.summary     = "Check your gem dependencies"
  s.description = "Check for a given github project if gem dependencies are up to date"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 2.12.0"
  s.add_development_dependency "mocha", "~> 0.13.0"
  s.add_runtime_dependency "bundler"
  s.add_runtime_dependency "progressbar"
end
