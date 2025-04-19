# lib/rate_limiter/storage/redis.rb
module RateLimiter
  module Storage
    class Redis < Base
      EXPIRATION_TIME = 60  # 60 seconds = 1 minute

      def initialize(options = {})
        default_options = {
          host: 'localhost',
          port: 6379
        }

        default_options[:namespace] = 'rate_limiter'

        @options = default_options.merge(options)
        @redis = ::Redis.new(@options)
      end

      def add_request(client_id)
        key = cache_key(client_id)
        @redis.multi do |redis|
          redis.lpush(key, Time.now.to_i)
          redis.expire(key, EXPIRATION_TIME)
        end
      end

      def requests_in_last_minute(client_id)
        key = cache_key(client_id)
        one_minute_ago = Time.now.to_i - EXPIRATION_TIME
        
        @redis.lrange(key, 0, -1).map(&:to_i).select do |timestamp|
          timestamp > one_minute_ago
        end
      end

      private

      def cache_key(client_id)
        [@options[:namespace], 'rate_limit', client_id].compact.join(':')
      end
    end
  end
end
