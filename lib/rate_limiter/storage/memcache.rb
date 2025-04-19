module RateLimiter
  module Storage
    class Memcache < Base
      # Compare Memcache with the rack-attack gem code
      # https://github.com/kickstarter/rack-attack/blob/master/lib/rack/attack/storage/memcache.rb
      def initialize
        @cache = Dalli::Client.new
      end

      def add_request(client_id)
        key = "rate_limit:#{client_id}"
        timestamps = @cache.get(key) || []
        timestamps << Time.now.to_i
        @cache.set(key, timestamps, 60) # Set to expire as defined in the configuration
      end

      def requests_in_last_minute(client_id)
        key = "rate_limit:#{client_id}"
        timestamps = @cache.get(key) || []
        one_minute_ago = Time.now.to_i - 60
        timestamps.select { |timestamp| timestamp > one_minute_ago }
      end
    end
  end
end
