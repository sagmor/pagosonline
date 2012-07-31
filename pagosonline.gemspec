# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pagosonline/version"

Gem::Specification.new do |s|
  s.name        = "pagos_online"
  s.version     = Pagosonline::VERSION
  s.authors     = ["Sebastian Gamboa"]
  s.email       = ["me@sagmor.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "pagosonline"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "hashie"
end
