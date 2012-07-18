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

  describe '#save' do
  end

  describe '#set_indexes' do
    it 'does not require #fields_to_index to be defined'
    it 'sets indexes for specified fields'
    it 'does not set indexes for non-specified fields'
    it 'clears preexisting indexes'
  end

  describe '#delete_all' do
  end

  describe '#de_camel' do
  end

  describe '#for_key' do
    it 'fetches items for keys which exist'
    it 'returns null when the key does not exist'
  end

  describe '#for_index' do
  end

  describe '#gen_key' do
    it 'produces no duplicates when called a bunch of times'
  end
end

