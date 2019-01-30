# Graphick

Graphick (a bad play on words of 'graph' and 'quick') is a utility to make generating and maintaining performance analysis graphs for applications much faster.

It has a straightforward DSL for defining data sources and data filters, and caches data and graphs based on the application binary checksum so graphs can be added or changed without regenerating all of the data.

## Example

The following generates a graph of 1..10 to the corresponding multiple of 6.

```
command echo "6 * $num " | bc

varying $num sequence 1 to 10
data output all
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphick'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install graphick

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/graphick.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
