## Hola!

You have probably heard of N+1 queries problem. In the rails community, there are a [bullet](https://github.com/flyerhzm/bullet) and [rspec-sqlimit](https://github.com/nepalez/rspec-sqlimit) gems that help to detect this kind of queries. `sequel_query_limit` is a [Sequel](https://github.com/jeremyevans/sequel) extension that pursuits the very much similar goal as `rspec-sqlimit` does. Maybe a little more :)

> PLEASE NOTE IT IS NOT READY BY ANY MEANS, SPECS ARE MISSING & ANALYSIS IS REALLY SUCKS ATM :D


## Usage

First of all, we shall enable an extension as described in the [sequel docs](https://github.com/jeremyevans/sequel/blob/master/doc/extensions.rdoc#database-extensions)

```ruby
require 'query_limit'
Sequel::Database.extension(:query_limit)
```


#### With RSpec

```ruby
module SqlHelper
  def self.included(base)
    base.before(:each) { QueryLimit::Listener::Global.watch }
    base.after(:each)  { QueryLimit::Listener::Global.analyze(np1: true, reset: true) }
    base.after(:all)   { QueryLimit::Listener::Global.die }
  end
end

RSpec.configure do |config|
  config.include SqlHelper, watch_sql: true
end

RSpec.describe App::Companies::Serializer, :watch_sql do
  subject { described_class.new(company).to_hash }

  let(:company) { Fabricate(:company) }

  it 'serializes company with its associations', :watch_sql do
    is_expected.to have_key :users
  end
end
```

If `query_limit` will catch up N+1 query it will print an SQL query with its backtrace to the STDOUT.

Using this technique you can check individual (or group of) examples for N+1 quries withouth wrapping everything into `DB.with_query_limit` block.


#### `DB.with_query_limit`

```ruby
DB.with_query_limit(/SELECT/, max: 3) do
  collection = Models::Company.limit(10).all
  App::Companies::Serializer.for_collection.new(collection).to_hash
end
```

This will return result of your query if it's not exceeding specified `max` limit. Otherwise, it will raise an exception with captured sql queries.

May be useful for ad-hoc testing via console.


## TODO

- Add configuration option for what to do when query exceeds a limit (raise exception or run a callback)
- Add configuration option for what to do when N+1 problem found
- Add RSpec matchers
- Add option to limit by query execution time
- Add ability to pass custom sql backrace formatter
- Add ability to analyze on the fly


## Contributing

Bug reports and pull requests are welcome!


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

