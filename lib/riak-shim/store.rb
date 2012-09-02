require 'riak'
require 'uuidtools'

module Riak
  module Shim
    # Represents a connection to a particular Riak instance
    class Store

      # The path to our configuration file.  Defaults to DEFAULT_CONFIG_LOCATION
      attr_writer :config_location

      # @!attribute [w]
      # [Riak::Client] the underlying Riak connection
      attr_writer :riak

      DEFAULT_CONFIG_LOCATION = 'config/database.yml'

      # Thrown when we can't find a configuration which matches the
      # current RACK_ENV
      class NoSettingsForCurrentEnvError < StandardError; end

      # Thrown when the RACK_ENV environment variable is not set
      class RackEnvNotSetError < StandardError; end

      # @return [Hash] the configuration for our current environment
      def config
        env = ENV['RACK_ENV'] or raise RackEnvNotSetError.new
        @config ||= read_config[env]
        @config or raise NoSettingsForCurrentEnvError.new(
            "RACK_ENV #{ENV['RACK_ENV']} not specified in #{config_location}.")
      end

      # @return [Hash] the entire config, ie the configuration for each environment
      def read_config
        YAML.load_file(config_location)
      end

      def config_location
        @config_location ||= DEFAULT_CONFIG_LOCATION
      end

      # @return [String] the prifix we will add to the bucket name for each class
      def bucket_prefix
        return config['bucket_prefix']
      end

      def riak
        @riak ||= Riak::Client.new(:http_backend => :Excon,
            :nodes => [{:host => config['host'], :http_port => config['http_port']}])
      end

      # @return [Riak::Bucket] the bucket for the coresponding name
      def bucket(name)
        riak.bucket(name)
      end
    end
  end
end
