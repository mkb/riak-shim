require 'spec_helper'
require 'riak-shim/persistable'

class PersistableExample
  include Riak::Shim::Persistable
  attr_accessor :foo, :bar, :baz
end

describe 'persistable' do
  let(:persistable) { PersistableExample.new }

  before do
    Riak::Shim::Store.any_instance.stub(:read_config).and_return(DB_CONFIG)
  end

  describe '#bucket_name' do
    it 'composes #db_name and class name' do
      persistable.bucket_name.should == 'test_persistable_example'
    end
  end

  describe '#bucket' do
    it 'returns the correct bucket' do
      persistable.bucket.name.should == 'test_persistable_example'
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
    before do
      @indexes = Hash.new { |hash, key| hash[key] = [] }
      @indexes[:oldkey] = ['oldval']
    end

    context 'with a model which does not need indes' do
      it 'does not require #fields_to_index to be defined' do
        expect { persistable.set_indexes(@indexes) }.to_not raise_error
      end

      it 'clears preexisting indexes' do
        persistable.set_indexes(@indexes)
        @indexes.should be_empty
      end
    end

    context 'with a model which needs indexes' do
      class PersistableExampleWithIndex < PersistableExample
        def fields_to_index
          [:bar, :baz]
        end
      end

      let(:indexable) { PersistableExampleWithIndex.new }
      before do
        indexable.foo = 1
        indexable.bar = 2
        indexable.baz = 3
        indexable.set_indexes(@indexes)
      end

      it 'sets indexes for specified fields and no others' do
        @indexes.keys.should =~ ['bar_bin', 'baz_bin']
      end
    end
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

