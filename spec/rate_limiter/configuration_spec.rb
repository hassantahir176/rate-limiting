RSpec.describe RateLimiter::Configuration do
  let(:config) { RateLimiter::Configuration.new }

  describe 'default configuration' do
    it 'sets default requests per minute' do
      expect(config.requests_per_minute).to eq(60)
    end

    it 'sets default storage type to memory' do
      expect(config.storage_type).to eq(:memory)
    end

    it 'sets default redis options' do
      expect(config.redis_options).to eq({ host: 'localhost', port: 6379 })
    end
  end

  describe 'configuration changes' do
    it 'allows setting requests per minute' do
      config.requests_per_minute = 100
      expect(config.requests_per_minute).to eq(100)
    end

    it 'allows setting storage type' do
      config.storage_type = :redis
      expect(config.storage_type).to eq(:redis)
    end

    it 'allows setting redis options' do
      new_options = { host: 'redis.example.com', port: 6380 }
      config.redis_options = new_options
      expect(config.redis_options).to eq(new_options)
    end
  end
end
