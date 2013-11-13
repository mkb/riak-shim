$: << './lib'
require 'riak-shim'
require 'awesome_print'

begin
  require 'pry'
rescue LoadError
end

ENV['RACK_ENV'] = 'test' unless ENV['RACK_ENV']
DB_CONFIG = { 'development' => { 'bucket_prefix' => 'dev_', 'host' => "localhost", 'http_port' => 8098},
    'test' => {'bucket_prefix' => 'test_', 'host' => "localhost", 'http_port' => 8098 }}

Riak.disable_list_keys_warnings = true
