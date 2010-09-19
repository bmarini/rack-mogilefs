version = ARGV.pop

puts "Building and pushing Rack::MogileFS..."
`gem build rack-mogilefs.gemspec`
`gem push rack-mogilefs-#{version}.gem`
`rm rack-mogilefs-#{version}.gem`
