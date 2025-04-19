# lib/rate_limiter/middleware.rb
module RateLimiter
  class Middleware
    def initialize(app)
      @app = app
      @config = RateLimiter.config
      @storage = RateLimiter.storage
    end

    def call(request)
      client_id = request['REMOTE_ADDR']
      @storage.add_request(client_id)

      puts "********************************************************"
      puts "Requests in last minute: #{@storage.requests_in_last_minute(client_id).size}"
      puts "********************************************************"

      if @storage.requests_in_last_minute(client_id).size > @config.requests_per_minute
        [429, { 'Content-Type' => 'text/plain' }, ['Rate limit exceeded. Try again later.']]
      else
        @app.call(request)
      end
    end
  end
end
