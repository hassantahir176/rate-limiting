module RateLimiter
  module Storage
    class Base
      def add_request(client_id)
        raise NotImplementedError, "Subclasses must implement this method"
      end

      def requests_in_last_minute(client_id)
        raise NotImplementedError, "Subclasses must implement this method"
      end
    end
  end
end
