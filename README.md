## What this is about?

You have probably heard of N+1 queries problem. In the rails community, there are a [bullet](https://github.com/flyerhzm/bullet) and [rspec-sqlimit](https://github.com/nepalez/rspec-sqlimit) gems that help to detect this kind of queries. `sequel_query_limit` is a [Sequel](https://github.com/jeremyevans/sequel) extension that pursuits the very much similar goal as `rspec-sqllmit` does. Maybe a little more :)


## Usage

#### `#with_query_limit`

```ruby
DB.with_query_limit(/SELECT/, max: 3) do
  collection = Models::Company.limit(10).all
  App::Companies::Serializer.for_collection.new(collection).to_hash
end
```

This will return result of your query if it's not exceeding specified `max` limit. Otherwise, it will raise and exception with captured sql queries.

#### Haven't figured out the name yet

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

## TODO

- Add configuration option for what to do when query exceeds a limit (raise exception or run a callback)
- Add configuration option for what to do when N+1 problem found
- Add RSpec matchers
- Add option to limit by query execution time
- Add ability to pass custom sql backrace formatter
- Add ability to analyze on the fly


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sequel_query_limit.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

