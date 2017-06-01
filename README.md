## What this is about?

You have probably heard of N+1 queries problem. In the rails community, there are a [bullet](https://github.com/flyerhzm/bullet) and [rspec-sqlimit](https://github.com/nepalez/rspec-sqlimit) gems that help to detect this kind of queries. `sequel_query_limit` is a [Sequel](https://github.com/jeremyevans/sequel) extension that pursuits the very much similar goal as `rspec-sqlimit` does. Maybe a little more :)


## Usage

#### With RSpec

```ruby
module SqlSpecHelper
  def self.included(base)
    base.before(:each) { QueryLimit::Listener::Global.watch }
    base.after(:each)  { QueryLimit::Listener::Global.analyze(np1: true, reset: true) }
    base.after(:all)   { QueryLimit::Listener::Global.die }
  end
end

RSpec.configure do |config|
  config.include SqlSpecHelper, watch: :np1
end

RSpec.describe 'analyzer', watch: :np1 do
  it 'analyzes queries that has been run' do
    collection = Models::Company.limit(10).all
    App::Companies::Serializer.for_collection.new(collection).to_hash
    expect(true).to eq true
  end
end
```

Using this technique you can check individual examples for N+1 quries withouth wrapping everything into `DB.with_query_limit` block.


#### `#with_query_limit`

Maybe useful for ad-hoc testing via console. This also can be used in tests.

```ruby
DB.with_query_limit(/SELECT/, max: 3) do
  collection = Models::Company.limit(10).all
  App::Companies::Serializer.for_collection.new(collection).to_hash
end
```

This will return result of your query if it's not exceeding specified `max` limit. Otherwise, it will raise an exception with captured sql queries.

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

