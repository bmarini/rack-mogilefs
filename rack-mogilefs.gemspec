# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rack/mogilefs/version"

Gem::Specification.new do |s|
  s.name        = "rack-mogilefs"
  s.version     = Rack::MogileFS::VERSION
  s.platform    = Gem::Platform::RUBY

  s.summary     = "A rack middleware and/or endpoint to serve up files from MogileFS"
  s.email       = "bmarini@gmail.com"
  s.homepage    = "http://github.com/bmarini/rack-mogilefs"
  s.description = "A rack middleware and/or endpoint to serve up files from MogileFS"
  s.authors     = ["Ben Marini"]

  s.rubyforge_project = "rack-mogilefs"

  s.add_dependency "mogilefs-client", ">= 2.1.0"
  s.add_dependency "rack", ">= 1.1.0"
  s.add_development_dependency "mocha"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
