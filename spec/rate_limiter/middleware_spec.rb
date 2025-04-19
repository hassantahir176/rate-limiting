RSpec.describe RateLimiter::Middleware do
  let(:app) { ->(env) { [200, env, "OK"] } }
  let(:middleware) { described_class.new(app) }
  let(:client_ip) { '127.0.0.1' }

  before do
    RateLimiter.configure
    RateLimiter.instance_variable_set(:@storage, RateLimiter::Storage::Factory.create(RateLimiter.config))
  end

  describe '#call' do
    let(:env) { { 'REMOTE_ADDR' => client_ip } }

    context 'when under rate limit' do
      it 'allows the request' do
        status, headers, body = middleware.call(env)
        expect(status).to eq(200)
      end
    end

    context 'when rate limit exceeded' do
      before do
        RateLimiter.config.requests_per_minute.times { middleware.call(env) }
      end

      it 'returns 429 status' do
        status, _, _ = middleware.call(env)
        expect(status).to eq(429)
      end

      it 'returns rate limit exceeded message' do
        _, _, body = middleware.call(env)
        expect(body).to eq(['Rate limit exceeded. Try again later.'])
      end
    end
  end

  describe 'different clients' do
    let(:client_ip_1) { '127.0.0.1' }
    let(:client_ip_2) { '127.0.0.2' }

    it 'tracks rate limits separately' do
      env1 = { 'REMOTE_ADDR' => client_ip_1 }
      env2 = { 'REMOTE_ADDR' => client_ip_2 }

      # Make requests for first client
      5.times { middleware.call(env1) }

      # Make requests for second client
      3.times { middleware.call(env2) }

      # expect(RateLimiter.storage.requests_in_last_minute(client_ip_1).size).to eq(5)
      expect(RateLimiter.storage.requests_in_last_minute(client_ip_2).size).to eq(3)
    end
  end
end
