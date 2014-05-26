# -*- encoding: utf-8 -*-
require File.expand_path('../lib/riak-shim/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Michael Brodhead, Shai Rosenfeld, and Larry Diehl"]
  gem.email         = ["mkb@engineyard.com"]
  gem.description   = %q{Riak shim for bucket naming and config.}
  gem.summary       = %q{A tiny shim between you and riak-client. Reads config/database.yml and generates sensible bucket names.}
  gem.homepage      = "https://github.com/mkb/riak-shim"
  gem.licenses      = "MIT"

  gem.files         = `git ls-files`.split($\)
  gem.files.reject!   {|f| f =~ %r{^vendor}}
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "riak-shim"
  gem.require_paths = ["lib"]
  gem.version       = Riak::Shim::VERSION

  gem.add_runtime_dependency 'riak-client', '~> 1.4', '>= 1.4.4'
  gem.add_runtime_dependency 'excon', '~> 0.33', '>= 0.33.0'
  gem.add_runtime_dependency 'uuidtools', '~> 0'
  gem.add_runtime_dependency 'json', '~> 0'
  gem.add_development_dependency 'rake', '~> 0'
  gem.add_development_dependency 'rspec', '~> 0'
  gem.add_development_dependency 'gem-release', '~> 0'
  gem.add_development_dependency 'awesome_print', '~> 0'
end
