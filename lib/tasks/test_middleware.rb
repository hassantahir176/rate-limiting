# test_middleware.rb
require 'byebug'
require_relative 'lib/rate_limiter'

RateLimiter.configure do |config|
  config.requests_per_minute = 100
end

app = ->(env) { [200, { 'Content-Type' => 'text/plain' }, ['Hello, World!']] }
middleware = RateLimiter::Middleware.new(app, RateLimiter.config, RateLimiter.storage)

# Simulate a request
env = { 'REMOTE_ADDR' => '127.0.0.1' }
middleware.call(env)
