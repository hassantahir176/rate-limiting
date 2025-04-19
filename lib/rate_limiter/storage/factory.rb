module RateLimiter
  module Storage
    class Factory
      def self.create(config)
        case config.storage_type
        when :memory
          Memory.new
        when :memcache
          Memcache.new
        when :redis
          Redis.new(config.redis_options)
        else
          raise ArgumentError, "Unknown storage type: #{config.storage_type}"
        end
      end
    end
  end
end
