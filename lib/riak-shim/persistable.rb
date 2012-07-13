module Riak
  module Shim

    module Persistable
      attr_writer :store
      attr_accessor :key

      def key
        @key ||= self.class.gen_key
      end

      def bucket
        return self.class.store.bucket(bucket_name)
      end

      def bucket_name
        self.class.bucket_name
      end

      def store
        self.class.store
      end

      def save
        doc = bucket.get_or_new(key)
        doc.data = to_hash
        set_indexes(doc.indexes)
        doc.store
        self
      end

      def set_indexes(indexes)
        indexes.clear
        fields_to_index.each do |field|
          index_name = "#{field}_bin"
          index_value = send(field)
          indexes[index_name] << index_value
        end
      end

      module ClassMethods
        def delete_all
          bucket.keys.each do |key|
            bucket.delete key
          end
        end

        def store
          @store ||= Store.new
        end

        def bucket_name
          myclass = de_camel(self.to_s)
          "#{store.bucket_prefix}#{myclass}"
        end

        def de_camel(classname)
          classname.gsub(/::/, '__').
            gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
            gsub(/([a-z\d])([A-Z])/,'\1_\2').
            tr("-", "_").
            downcase
        end

        def bucket
          return store.bucket(bucket_name)
        end

        def for_key(key)
          begin
            raw = bucket.get(key)
            data = raw.data
            from_hash(data)
          rescue Riak::HTTPFailedRequest
            return nil
          end
        end

        def for_index(index, value)
          bucket.get_index(index, value).map do |key|
            for_key(key)
          end
        end

        def gen_key
          UUIDTools::UUID.random_create.to_s
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end