# Riak Shim

A tiny shim between you and riak-client. Reads database config and handles a
little plumbing for marshalling and unmarshalling your models.

Riak is a database from the good people at Basho.  Check it out:
http://basho.com/products/riak-overview/

[![Build Status](https://secure.travis-ci.org/mkb/riak-shim.png?branch=master)](http://travis-ci.org/mkb/riak-shim)
[![Dependency Status](https://gemnasium.com/mkb/riak-shim.png)](https://gemnasium.com/mkb/riak-shim)
[![Code Climate](https://codeclimate.com/github/mkb/riak-shim.png)](https://codeclimate.com/github/mkb/riak-shim)

## Installation

Add this line to your application's Gemfile:

    gem 'riak-shim'

And then execute:

    $ bundle

Or install directly with:

    $ gem install riak-shim

## Usage

Create a config/database.yml containing the details of your Riak setup like so:

    development: &default
      bucket_prefix: myapp_dev_
      host: localhost
      http_port: 8098

    test:
      <<: *default
      bucket_prefix: myapp_test_

    production:
      <<: *default
      bucket_prefix: myapp_production_

`bucket_prefix` will be prefixed to each bucket name, allowing you to point
multiple applications (or multiple copies of the same application) at a single
Riak install. During development, this prevents you from stepping on your own
toes.

## Converting a model to use Riak

In any class you wish to persist, you must include the module:

    require 'riak-shim'
    include Riak::Shim::Persistable

Then, write a #to_hash method which returns a hash representing your object
(and consequently, what you are going to store):

    def to_hash
      # Return hashified version of your class
      { 'foo' => @foo, 'bar' => @bar }
    end

You'll use Class#from_hash to create an instance from the hash which was
pulled from Riak:

    def self.from_hash(data)
      # Return a fresh instance of your class populated by the hash provided
      your_obj = new
      your_obj.foo = data['foo']
      your_obj.bar = data['bar']
      return your_obj
    end

You can now save instances of your class by calling `#save` and later retrieve
them from Riak by calling `.for_key`:

    an_instance.save
    key = an_instance.key
    retrieved_copy = YourClass.for_key(key)

### Secondary indexes

Secondary indexes in Riak allow you to query based on the contents of a
particular field.  If you'd like to look up your data by the contents of
fields, define `#fields_to_index` and return the names of any fields you wish
to query on.  When you #save an instance of YourClass, riak-shim will populate
a secondary index for that field.

    def fields_to_index
      # Return an Array of hash keys you would like placed into a secondary index.
      [foo]
    end

The `for_index` method retrieves all records whose value for the given index
matches:

    YourClass.for_index('foo_bin', 'some foo')

...where `index_name` is what you defined in `fields_to_index` plus the suffix
"_bin" .

The `value` is what you want to look up.

Return value is an Array of instances of your class matching the query.


## Contributing

Pull requests are very welcome! If you have trouble with your contribution
go ahed and open a pull request and I'll be happy to work with you.
