
# Provides basic persistence features
module Riak
  module Shim
    module Persistable
      attr_writer :key

      # @return [String] the unique key for storing the object in Riak
      def key
        @key ||= self.class.gen_key
      end

      # @return [Riak::Bucket] your app's Riak bucket for this class
      def bucket
        return self.class.store.bucket(bucket_name)
      end

      # @return [String] name of the Riak bucket generated from the class name and your configuration
      def bucket_name
        self.class.bucket_name
      end

      # @return [Riak::Shim::Store] the Store you are connected to
      def store
        self.class.store
      end

      # Persist this object into Riak
      def save
        doc = bucket.get_or_new(key)
        doc.data = to_hash
        set_indexes(doc.indexes)
        doc.store
        self
      end

      # Remove this object from Riak
      def destroy
        bucket.delete(key)
      end

      module ClassMethods
        # Remove all instances of this class from Riak.
        #
        # *WARNING:* This is very slow and is intended only for your tests, not for production use.
        def delete_all
          bucket.keys.each do |key|
            bucket.delete(key)
          end
        end

        # @return [Riak::Shim::Store] the store you are connected to
        def store
          @store ||= Store.new
        end

        # @return [String] name of the Riak bucket generated from the class name and your configuration
        def bucket_name
          myclass = de_camel(self.to_s)
          "#{store.bucket_prefix}#{myclass}"
        end

        # @return [Riak::Bucket] your app's Riak bucket for this class
        def bucket
          return store.bucket(bucket_name)
        end

        def for_key(key)
          begin
            raw = bucket.get(key)
            data = raw.data
            result = from_hash(data)
            result.key = key
            result
          rescue Riak::HTTPFailedRequest
            return nil
          end
        end

        # @return [Array] any instances of your class whose indexed field matches value
        # *NOTE:* This interface is ugly as sin, so expect it to change in a future release.
        def for_index(index, value)
          bucket.get_index(index, value).map do |key|
            for_key(key)
          end
        end

        # @return [String] a UUID which we will use as our key
        def gen_key
          UUIDTools::UUID.random_create.to_s
        end


        # @return [Integer] the number of instances of your class stored in Riak
        #
        # *WARNING:* This is very slow and is intended only for your tests, not for production use.
        def count
          counter = 0
          bucket.keys {|keys| counter += keys.count }
          return counter
        end

        protected
        def de_camel(classname)
          classname.gsub(/::/, '__').
            gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
            gsub(/([a-z\d])([A-Z])/,'\1_\2').
            tr("-", "_").
            downcase
        end
      end

      protected

      def self.included(base)
        base.extend(ClassMethods)
      end

      def set_indexes(indexes)
        indexes.clear
        if self.respond_to?(:fields_to_index)
          fields_to_index.each do |field|
            index_name = "#{field}_bin"
            index_value = send(field)
            indexes[index_name] << index_value
          end
        end
      end


    end
  end
end
