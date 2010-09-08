Gem::Specification.new do |s|
  s.name        = "rack-mogilefs"
  s.version     = "0.1.1"
  s.date        = "2010-09-08"
  s.summary     = "A rack middleware and/or endpoint to serve up files from MogileFS"
  s.email       = "bmarini@gmail.com"
  s.homepage    = "http://github.com/bmarini/rack-mogilefs"
  s.description = "A rack middleware and/or endpoint to serve up files from MogileFS"
  s.authors     = ["Ben Marini"]
  s.files       = Dir.glob("lib/**/*") + %w(README.md Rakefile)
  s.test_files  = Dir.glob("test/**/*")

  s.add_dependency "mogilefs-client", "~> 2.1.0"
  s.add_dependency "mime-types", "1.16"

  s.add_development_dependency "rack"
  s.add_development_dependency "mocha"
end
