# -*- encoding: utf-8 -*-
require File.expand_path('../lib/riak-shim/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Michael Brodhead, Shai Rosenfeld, and Larry Diehl"]
  gem.email         = ["mkb@engineyard.com"]
  gem.description   = %q{Riak shim for bucket naming and config.}
  gem.summary       = %q{A tiny shim between you and riak-client. Reads config/database.yml and generates sensible bucket names.}
  gem.homepage      = "https://github.com/mkb/riak-shim"

  gem.files         = `git ls-files`.split($\)
  gem.files.reject!   {|f| f =~ %r{^vendor}}
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "riak-shim"
  gem.require_paths = ["lib"]
  gem.version       = Riak::Shim::VERSION

  gem.add_dependency 'riak-client', '~>1.4.2'
  gem.add_dependency 'excon', '~>0.29.0'
  gem.add_dependency 'uuidtools', '~>2.1.4'
  gem.add_dependency 'json'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'gem-release'
  gem.add_development_dependency 'awesome_print'
end
