# Riak::Shim

A teeny shim between your code and the riak-client gem.  Reads database configuration
out of config/database.yml and derives bucket names from your class names and an
appropriate prefix.

Riak is a database from the good people at Basho.  Check it out:  http://basho.com/products/riak-overview/

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

In any class you wish to persist:
  include Riak::Shim::Persistable

  def to_hash
    # Return hashified version of your class
  end

  def self.from_hash(key)
    # Return a fresh instance of your class populated by the hash provided
  end

  def fields_to_index
    # Return an Array of hash keys you would like placed into a secondary index.
    # Return an empty Array if you don't know what this means.  :)
  end

Now you can save instances of that class by calling #save on them and retrieve them from Riak by calling

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

- #from_hash does not work as advertised
- Implement a #for_key lookup method
- Examples directory
- Revisit tests
