require 'riak'
require 'uuidtools'

module Riak
  module Shim
    class Store
      attr_writer :config_location
      attr_writer :riak

      class NoSettingsForCurrentEnvError < StandardError; end
      class RackEnvNotSetError < StandardError; end

      def config
        env = ENV['RACK_ENV'] or raise RackEnvNotSetError.new
        @config ||= read_config[env]
        @config or raise NoSettingsForCurrentEnvError.new(
            "RACK_ENV #{ENV['RACK_ENV']} not specified in #{config_location}.")
      end

      def read_config
        YAML.load_file(config_location)
      end

      def config_location
        @config_location ||= 'config/database.yml'
      end

      def bucket_prefix
        return config['bucket_prefix']
      end

      def riak
        @riak ||= Riak::Client.new(:http_backend => :Excon,
            :nodes => [{:host => config['host'], :http_port => config['http_port']}])
      end

      def bucket(name)
        riak.bucket(name)
      end
    end
  end
end
