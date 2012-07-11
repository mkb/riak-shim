# -*- encoding: utf-8 -*-
require File.expand_path('../lib/riak-shim/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Michael Brodhead & Shai Rosenfeld"]
  gem.email         = ["mbrodhead@engineyard.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "riak-shim"
  gem.require_paths = ["lib"]
  gem.version       = Riak::Shim::VERSION

  gem.add_dependency 'riak-client'
  gem.add_dependency 'uuidtools'

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
end
