# ErrorBuilder

This is a Ruby gem that allows you to build structured error objects in a flexible and configurable way.

## Requirements

Before you begin, ensure you have met the following requirements:

- Ruby version 3.1.0 or newer. You can check your Ruby version by running `ruby -v`.
- Bundler installed. You can install Bundler with `gem install bundler`.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add error_builder

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install error_builder

## Usage

### Configuration

If you have to use in Rails:
1. Add to `Gemfile`
```ruby
  gem 'error_builder'
```

2. Run `bundle i`

3. You can configure the gem by using the ErrorBuilder.configure block:
```ruby
ErrorBuilder.configure do |config|
  config.format         = :hash   # Supported formats: :hash, :array, custom class format
  config.message_format = :string # Supported formats: :string, :array
end
```

### How To Use

1. Create an Error Engine
```ruby
errors = ErrorBuilder::Engine.new
```

2. Add Errors
```ruby
errors.add(:base, "Something went wrong")
```

3. Convert Errors to Hash or Array (depends on configuration)
```ruby
errors.to_h    #=> { base: ["Something went wrong"] }
```

### Including in Classes
You can include ErrorBuilder in your classes to use the `errors` method:
```ruby
class MyService
  include ErrorBuilder

  def call 
    errors.add(:base, "Something went wrong")

    true
  end
end

my_service = MyService.new
my_service.call
my_service.errors.to_h    #=> { base: ["Something went wrong"] }
```

### Examples

#### Using nested keys

```ruby
class MyService
  include ErrorBuilder

  def call 
    errors.add("user.locations[0].name", "must be present")

    true
  end
end

my_service = MyService.new
my_service.call
my_service.errors.to_h             #=> { "user" => { "locations" => { 0 => { "name" => ["must be present"] } } } } }
my_service.errors.to_h(flat: true) #=> { "user.locations[0].name" => ["must be present"] }
```

#### Using custom formats

```ruby
class CustomFormat
  def initialize(errors, **)
    @errors = errors
  end

  def to_h
    @errors.map { |error| "#{error.key} #{error.message.join(", ")}" }
  end
end

errors = ErrorBuilder::Engine.new(format: CustomFormat)
errors.add(:base, "Something went wrong")
errors.to_h    #=> ["base Something went wrong"]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. Then, eun `rake rubocop` to run the rubocop. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mmarusyk/error_builder. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/mmarusyk/error_builder/blob/main/CODE_OF_CONDUCT.md). You can find a list of contributors in the [CONTRIBUTORS.md](https://github.com/mmarusyk/error_builder/blob/main/CONTRIBUTORS.md) file.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the error_builder project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mmarusyk/error_builder/blob/main/CODE_OF_CONDUCT.md).
