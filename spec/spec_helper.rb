$: << './lib'
require 'riak-shim'

DB_CONFIG = { 'development' => { 'bucket_prefix' => 'dev_', 'host' => "localhost", 'http_port' => 8098},
    'test' => {'bucket_prefix' => 'test_', 'host' => "localhost", 'http_port' => 8098 }}
