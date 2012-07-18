# Riak::Shim

A teeny shim between your code and the riak-client gem.  Reads database configuration
out of config/database.yml and derives bucket names from your class names and an
appropriate prefix.

Riak is a database from the good people at Basho.  Check it out:  http://basho.com/products/riak-overview/

[![Build Status](https://secure.travis-ci.org/mkb/riak-shim.png?branch=master)](http://travis-ci.org/mkb/riak-shim)


## Installation

Add this line to your application's Gemfile:

    gem 'riak-shim'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install riak-shim

## Usage

Create a config/database.yml containing the details of your Riak like so:

    development: &default
      bucket_prefix: dev_
      host: localhost
      http_port: 8098

    test:
      <<: *default
      bucket_prefix: test_

## Converting a model to use Riak

In any class you wish to persist, you must include the module:

    require 'riak-shim'
    include Riak::Shim::Persistable

Then, write a #to_hash method which returns a hash representing your object (and consequently, what you are
going to store):

    def to_hash
      # Return hashified version of your class
    end

You'll use Class#from_hash to create an instance from the hash which was pulled from Riak:

    def self.from_hash(data)
      your_obj = new
      your_obj.foo = data['foo']
      # Return a fresh instance of your class populated by the hash provided
      return your_obj
    end

You can now save instances of yoru class by calling #save and later retrieve them from Riak
by calling...

    YourClass.for_key(key)

### Secondary indexes

Secondary indexes in Riak allow you to query based on the contents of a particular field.  Define
YourClass#fields_to_index and return the names of any fields you wish to query on.  When you #save
an instance of YourClass, riak-shim will populate a secondary index for that field.

    def fields_to_index
      # Return an Array of hash keys you would like placed into a secondary index.
      # Return an empty Array if you don't know what this means. :)
    end

You can now retrieve records based on the content of those fields by calling...
The `for_index` method retrieves all records whose value for the given index matches.

    YourClass.for_index(index_name, value)

Where `index_name` is what you defined in `fields_to_index` plus the suffix "_bin" .

The `value` is what you want to look up.

Return value is an Array of instances of your class matching the query.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## TODOS

- Examples directory
- Revisit tests
