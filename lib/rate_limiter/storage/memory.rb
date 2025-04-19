module RateLimiter
  module Storage
    class Memory < Base
      def initialize
        @store = Hash.new { |hash, key| hash[key] = [] }
        @mutex = Mutex.new
      end

      def add_request(client_id)
        @mutex.synchronize do
          @store[client_id] << Time.now
        end
      end

      def requests_in_last_minute(client_id)
        @mutex.synchronize do
          one_minute_ago = Time.now - 60
          @store[client_id].select { |timestamp| timestamp > one_minute_ago }
        end
      end
    end
  end
end
