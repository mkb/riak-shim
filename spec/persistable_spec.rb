require 'spec_helper'
require 'riak-shim/persistable'

class PersistableTester
  include Riak::Shim::Persistable
end

describe 'persistable' do
  let(:persistable) { PersistableTester.new }

  before do
    Riak::Shim::Store.any_instance.stub(:read_config).and_return(DB_CONFIG)
  end

  describe '#bucket_name' do
    it 'composes #db_name and class name' do
      persistable.bucket_name.should == 'test_persistable_tester'
    end
  end

  describe '#bucket' do
    it 'returns the correct bucket' do
      persistable.bucket.name.should == 'test_persistable_tester'
    end
  end

  describe '#store' do
    it 'returns a something that provides buckets' do
      persistable.store.should respond_to(:bucket)
    end
  end
end

