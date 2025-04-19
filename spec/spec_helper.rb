# frozen_string_literal: true

require 'rate_limiter'
require 'byebug'
require 'redis'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  RSpec.configure do |config|
    config.before(:each) do
      # Reset RateLimiter configuration before each test
      RateLimiter.instance_variable_set(:@config, nil)
    end
  end
end
