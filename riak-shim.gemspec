# -*- encoding: utf-8 -*-
require File.expand_path('../lib/riak-shim/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Michael Brodhead & Shai Rosenfeld"]
  gem.email         = ["mkb@engineyard.com"]
  gem.description   = %q{Riak shim for bucket names and config.}
  gem.summary       = %q{A tiny shim between you and riak-client. Reads config/database.yml and generates sensible bucket names.}
  gem.homepage      = "https://github.com/mkb/riak-shim"

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
  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-rspec"
end
