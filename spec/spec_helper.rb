$: << './lib'
require 'riak-shim'
require 'pry' if Gem.available?('pry')
require 'awesome_print'

ENV['RACK_ENV'] = 'test' unless ENV['RACK_ENV']
DB_CONFIG = { 'development' => { 'bucket_prefix' => 'dev_', 'host' => "localhost", 'http_port' => 8098},
    'test' => {'bucket_prefix' => 'test_', 'host' => "localhost", 'http_port' => 8098 }}

Riak.disable_list_keys_warnings = true
