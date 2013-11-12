module Riak
  module Shim
    module Persistable
      class SecondaryIndexQuery
        def initialize(obj, idx)
          @obj = obj
          @idx = idx =~ /_bin$/ ? idx : "#{idx}_bin"
        end

        def [](key)
          @obj.for_index(@idx, key)
        end
      end
    end
  end
end
