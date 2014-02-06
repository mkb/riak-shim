require 'spec_helper'
require 'riak-shim/store'

describe Riak::Shim::Store do
  let(:store) { Riak::Shim::Store.new }

  # Port finding code stolen without remorse from realweb
  PORT_RANGE    = 8000..10000
  def find_port
    begin
      port = random_port
    end while system("lsof -i tcp:#{port} > /dev/null")
    port
  end

  def random_port
    PORT_RANGE.to_a[rand(PORT_RANGE.to_a.size)]
  end

  describe '#config_location' do
    it 'keeps a path of the database config file' do
      path = store.config_location
      path.should_not be_nil
    end
  end

  context 'with test config' do
    before do
      tmpdir = Dir.tmpdir
      FileUtils.cp('./spec/support/database.yml', tmpdir)
      store.stub(:config_location).and_return("#{tmpdir}/database.yml")
    end

    describe '#read_config' do
      it 'reads yaml from config_location' do
        store.read_config.should == DB_CONFIG
      end
    end

    describe 'error handling' do
      before do
        @stashed_rack_env = ENV['RACK_ENV']
      end

      after do
        ENV['RACK_ENV'] = @stashed_rack_env
      end

      context 'with current RACK_ENV not explicitly configured in database.yml' do
        before do
          ENV['RACK_ENV'] = 'production'
        end

        it "raises an error" do
          expect { store.config }.to raise_error(Riak::Shim::Store::NoSettingsForCurrentEnvError)
        end
      end

      context 'with no RACK_ENV set' do
        before do
          ENV['RACK_ENV'] = nil
        end

        it "should assume development" do
          store.config['bucket_prefix'].should == 'dev_'
        end
      end

      context 'with no riak at specified coordinates' do
        before do
          store.config['host'] = 'localhost'
          store.config['http_port'] = find_port
        end

        it 'raises an informative exception' do
          expect { store.riak }.to raise_error(Riak::Shim::Store::ConnectionError)
        end

        it 'includes an informative message' do
          expect { store.riak }.to raise_error(/Could not connect to Riak at/)
        end
      end
    end

    describe '#config' do
      context 'with RACK_ENV=test' do
        before do
          @stashed_rack_env = ENV['RACK_ENV']
          ENV['RACK_ENV'] = 'test'
        end

        after do
          ENV['RACK_ENV'] = @stashed_rack_env
        end

        it "says prefix is test_" do
          store.config['bucket_prefix'].should == 'test_'
        end
      end
    end

    describe '#bucket_prefix' do
      it 'uses the prefix from the config' do
        store.bucket_prefix.should == 'test_'
      end
    end
  end
end
