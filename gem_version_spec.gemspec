# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gem_version_check/version"

Gem::Specification.new do |s|
  s.name        = "gem_version_check"
  s.version     = GemVersionCheck::VERSION
  s.authors     = ["Frederik Dietz"]
  s.email       = ["frederik.dietz@xing.com"]
  s.homepage    = ""
  s.summary     = "Write a gem summary"
  s.description = "Write a gem description"

  s.rubyforge_project = "text_resources"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rake'
  s.add_runtime_dependency 'activesupport'
  s.add_runtime_dependency "bundler"
end
