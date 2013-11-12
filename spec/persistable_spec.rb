require 'spec_helper'
require 'riak-shim/persistable'
require 'support/camelcase'

class PersistableExample
  include Riak::Shim::Persistable
  attr_accessor :foo, :bar, :baz

  def to_hash
    { 'foo' => foo, 'bar' => bar, 'baz' => baz }
  end

  def self.from_hash(data)
    result = self.new
    result.foo = data['foo']
    result.bar = data['bar']
    result.baz = data['baz']
    result
  end

  def ==(other)
    other.instance_of?(self.class) and
    self.key == other.key and
    self.foo == other.foo and
    self.bar == other.bar and
    self.baz == other.baz
  end
end

class PersistableExampleWithIndex < PersistableExample
  def fields_to_index
    [:bar, :baz]
  end
end

def create_test_data(quantity)
  quantity.times do |i|
    p = PersistableExample.new
    p.foo, p.bar, p.baz = i, i, i
    p.save
  end
end

describe Riak::Shim::Persistable do
  let(:persistable) do
    p = PersistableExample.new ; p.foo = 'boo' ; p.bar = 'who' ; p
  end
  let(:bucket) { PersistableExample.bucket }

  before do
    Riak::Shim::Store.any_instance.stub(:read_config).and_return(DB_CONFIG)
  end

  after do
    PersistableExample.delete_all
  end

  describe '#bucket_name' do
    it 'composes #db_name and class name' do
      persistable.bucket_name.should == 'test_persistable_example'
    end
  end

  describe '#bucket' do
    it 'returns the correct bucket' do
      bucket.name.should == 'test_persistable_example'
    end
  end

  describe '#store' do
    it 'returns a something that provides buckets' do
      persistable.store.should respond_to(:bucket)
    end
  end

  describe '#save' do
    it 'increases key count' do
      expect do
        persistable.save
      end.to change{ bucket.keys.count }.by(1)
    end

    it 'can then be retrieved' do
      persistable.save
      retrieved = PersistableExample.for_key(persistable.key)
      retrieved.should eq persistable
    end
  end

  describe '#destroy' do
    before do
      persistable.save
      persistable.destroy
    end

    it 'removes the key' do
      bucket.exists?(persistable.key).should be_false
    end
  end

  describe '#set_indexes' do
    before do
      @indexes = Hash.new { |hash, key| hash[key] = [] }
      @indexes[:oldkey] = ['oldval']
    end

    context 'with a model which does not need indexes' do
      it 'does not require #fields_to_index to be defined' do
        expect { persistable.send(:set_indexes, @indexes) }.to_not raise_error
      end

      it 'clears preexisting indexes' do
        persistable.send(:set_indexes, @indexes)
        @indexes.should be_empty
      end
    end

    context 'with a model which needs indexes' do
      let(:indexable) { PersistableExampleWithIndex.new }
      before do
        indexable.foo = 1
        indexable.bar = 2
        indexable.baz = 3
        indexable.send(:set_indexes, @indexes)
      end

      after do
        PersistableExampleWithIndex.delete_all
      end

      it 'sets indexes for specified fields and no others' do
        @indexes.keys.should =~ ['bar_bin', 'baz_bin']
      end
    end
  end

  describe '#delete_all' do
    before do
      create_test_data(10)
      PersistableExample.delete_all
      sleep(5)
    end

    it 'has no instances in the DB' do
      PersistableExample.bucket.keys.count.should eq 0
    end
  end

  describe '#de_camel' do
    def de_camel(camelcase)
      PersistableExample.send(:de_camel, camelcase)
    end

    it 'handles a basic camel-case name' do
      DeCamel.each do |camelcase, lowered|
        de_camel(camelcase).should eq(lowered)
      end
    end

    it 'handles runs of capitals appropriately' do
      DeCamelCapsRuns.each do |camelcase, lowered|
        de_camel(camelcase).should eq(lowered)
      end
    end

    it 'turns module separators into slashes' do
      DeCamelWithModule.each do |camelcase, lowered|
        de_camel(camelcase).should eq(lowered)
      end
    end

    it 'does not produce collisions' do
      de_camel('RiakShim').should_not eq de_camel('Riak::Shim')
    end
  end

  describe '#for_key' do
    it 'fetches items for keys which exist' do
      persistable.save
      PersistableExample.for_key(persistable.key).should eq persistable
    end

    it 'returns null when the key does not exist' do
      PersistableExample.for_key('no such key').should be_nil
    end
  end

  describe '#for_index' do
    before do
      @indexed = []
      3.times do |i|
        indexable = PersistableExampleWithIndex.new
        indexable.foo = i
        indexable.bar = 'wombat'
        indexable.save
        @indexed << indexable
      end
    end

    after do
      PersistableExampleWithIndex.delete_all
    end

    it 'returns all items which match indexed value' do
      PersistableExampleWithIndex.for_index('bar_bin', 'wombat').should =~ @indexed
    end

    it 'returns an empty list when no matches are found' do
      PersistableExampleWithIndex.for_index('bar_bin', 'chew').should be_empty
    end
  end

  describe '#[]' do
    before do
      @indexed = []
      3.times do |i|
        indexable = PersistableExampleWithIndex.new
        indexable.foo = i
        indexable.bar = 'wombat'
        indexable.save
        @indexed << indexable
      end
    end

    after do
      PersistableExampleWithIndex.delete_all
    end

    it 'returns all items which match indexed value' do
      PersistableExampleWithIndex['bar_bin']['wombat'].should =~ @indexed
    end

    it 'returns an empty list when no matches are found' do
      PersistableExampleWithIndex['bar_bin']['chew'].should be_empty
    end
  end

  describe '#gen_key' do
    before do
      @keys = []
      20.times { @keys << PersistableExample.gen_key }
    end

    it 'produces no duplicates when called a bunch of times' do
      @keys.uniq!.should be_nil
    end
  end

  describe '#count' do
    COUNT = 50

    before do
      PersistableExample.delete_all
      sleep(5)
      create_test_data(COUNT)
    end

    it 'returns an accurate count' do
      PersistableExample.count.should eq COUNT
    end
  end
end
