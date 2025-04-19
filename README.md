# RateLimiter

A flexible rate limiting gem for Rack-based Ruby applications. Provides multiple storage options and easy configuration for API rate limiting.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
```

Alternatively, add this line to your application's Gemfile:

```ruby
gem 'UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG'
```

And then execute:

```bash
$ bundle install
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
```

## Usage

### Basic Setup

Add the middleware to your application:

#### For Rails Applications

```ruby
# config/application.rb
module YourApp
  class Application < Rails::Application
    config.middleware.use RateLimiter::Middleware
  end
end
```

#### For Rack Applications

```ruby
# config.ru
require 'rate_limiter'

RateLimiter.configure do |config|
  config.requests_per_minute = 100
end

use RateLimiter::Middleware
run YourApp
```

### Configuration

Configure the rate limiter with your desired settings:

```ruby
# config/initializers/rate_limiter.rb (for Rails)
RateLimiter.configure do |config|
  config.requests_per_minute = 100  # Number of requests allowed per minute
  config.storage_type = :memory     # Choose storage type (:memory, :redis, :memcache)

  # Redis configuration (if using Redis storage)
  config.redis_options = {
    host: 'localhost',
    port: 6379
  }
end
```

### Storage Options

The gem supports multiple storage backends:

#### Memory Storage (Default)
```ruby
RateLimiter.configure do |config|
  config.storage_type = :memory
end
```

#### Memcache Storage
```ruby
RateLimiter.configure do |config|
  config.storage_type = :memcache
end
```

#### Redis Storage
```ruby
RateLimiter.configure do |config|
  config.storage_type = :redis
  config.redis_options = {
    host: 'localhost',
    port: 6379
  }
end
```

### Rate Limit Exceeded Response

When the rate limit is exceeded, the middleware returns:

- Status: `429 Too Many Requests`
- Body: "Rate limit exceeded. Try again later."


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

TODO: Update the github url below
Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rate_limiter.

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create a new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RateLimiter project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md).
