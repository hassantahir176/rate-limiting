RSpec.describe RateLimiter::Storage::Memory do
  let(:storage) { described_class.new }
  let(:client_id) { '127.0.0.1' }

  describe '#add_request' do
    it 'adds a request for a client' do
      storage.add_request(client_id)
      expect(storage.requests_in_last_minute(client_id).size).to eq(1)
    end
  end

  describe '#requests_in_last_minute' do
    before do
      3.times { storage.add_request(client_id) }
    end

    it 'returns correct number of requests' do
      expect(storage.requests_in_last_minute(client_id).size).to eq(3)
    end

    it 'only returns requests from last minute' do
      allow(Time).to receive(:now).and_return(Time.now + 61)
      expect(storage.requests_in_last_minute(client_id).size).to eq(0)
    end
  end

  describe 'thread safety' do
    it 'handles concurrent requests' do
      threads = []
      10.times do
        threads << Thread.new do
          storage.add_request(client_id)
        end
      end
      threads.each(&:join)

      expect(storage.requests_in_last_minute(client_id).size).to eq(10)
    end
  end
end
