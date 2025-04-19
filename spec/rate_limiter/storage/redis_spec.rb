RSpec.describe RateLimiter::Storage::Redis, redis: true do
  let(:redis_options) { 
    { 
      host: 'localhost', 
      port: 6379,
      namespace: 'test_rate_limiter'  # Use test namespace
    } 
  }
  let(:storage) { described_class.new(redis_options) }
  let(:client_id) { '127.0.0.1' }
  let(:redis) { storage.instance_variable_get(:@redis) }

  before(:all) do
    begin
      Redis.new.ping
      @redis_available = true
    rescue Redis::CannotConnectError => e
      @redis_available = false
      puts "\nWARNING: Redis is not running. Please start Redis to run these tests."
    end
  end

  before(:each) do
    skip "Redis is not available" unless @redis_available
    # Clear only test namespace keys
    keys = redis.keys("#{redis_options[:namespace]}:*")
    redis.del(*keys) if keys.any?
  end

  describe '#add_request' do
    it 'adds a request to Redis' do
      storage.add_request(client_id)
      key = "#{redis_options[:namespace]}:rate_limit:#{client_id}"
      expect(redis.exists?(key)).to be true
      expect(storage.requests_in_last_minute(client_id).size).to eq(1)
    end

    it 'sets expiration on the key' do
      storage.add_request(client_id)
      key = "#{redis_options[:namespace]}:rate_limit:#{client_id}"
      expect(redis.ttl(key)).to be_between(0, described_class::EXPIRATION_TIME)
    end

    it 'expires keys after one minute' do
      storage.add_request(client_id)
      allow(Time).to receive(:now).and_return(Time.now + 61)
      expect(storage.requests_in_last_minute(client_id).size).to eq(0)
    end
  end

  describe '#requests_in_last_minute' do
    before do
      3.times { storage.add_request(client_id) }
    end

    it 'returns correct number of requests' do
      expect(storage.requests_in_last_minute(client_id).size).to eq(3)
    end

    it 'handles concurrent requests' do
      threads = []
      10.times do
        threads << Thread.new do
          storage.add_request(client_id)
        end
      end
      threads.each(&:join)

      expect(storage.requests_in_last_minute(client_id).size).to eq(13)
    end
  end
end
