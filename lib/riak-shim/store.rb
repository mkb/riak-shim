require 'riak'
require 'uuidtools'

module Riak
  module Shim

    # Represents a connection to a particular Riak cluster
    # @attr [String] config_location The path to our configuration file.  Defaults to DEFAULT_CONFIG_LOCATION
    # @attr [Riak::Client] riak The underlying Riak connection
    class Store

      attr_writer :config_location
      attr_writer :riak

      DEFAULT_CONFIG_LOCATION = 'config/database.yml'

      # Raised when we can't find a configuration which matches the
      # current RACK_ENV
      class NoSettingsForCurrentEnvError < StandardError; end

      # Raised when we can't connect to Riak
      class ConnectionError < StandardError; end

      # @return [Hash] the configuration for our current environment
      def config
        env = ENV['RACK_ENV'] || "development"
        @config ||= read_config[env]
        @config or raise NoSettingsForCurrentEnvError.new(
            "RACK_ENV #{env} not specified in #{config_location}.")
      end

      # @return [Hash] the entire config, ie the configuration for each environment
      def read_config
        YAML.load_file(config_location)
      end

      def config_location
        @config_location ||= DEFAULT_CONFIG_LOCATION
      end

      # @return [String] the prefix we will add to the bucket name for each class
      def bucket_prefix
        return config['bucket_prefix']
      end

      def riak
        return @riak if @riak

        @riak = Riak::Client.new(:http_backend => :Excon,
            :nodes => [{:host => config['host'], :http_port => config['http_port']}])
        unless @riak.ping
          @riak = nil
          raise ConnectionError.new("Could not connect to Riak at #{config['host']}:#{config['http_port']}")
        end

        @riak
      end

      # @return [Riak::Bucket] the bucket coresponding to name
      def bucket(name)
        riak.bucket(name)
      end
    end
  end
end
