module RateLimiter
  class Configuration
    attr_accessor :requests_per_minute, :storage_type, :redis_options

    def initialize
      @requests_per_minute = 60
      @storage_type = :memory
      @redis_options = { host: 'localhost', port: 6379 }
    end

    def storage_type=(type)
      @storage_type = type.to_sym
    end
  end
end
