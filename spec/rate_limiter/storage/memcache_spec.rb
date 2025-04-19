require 'spec_helper'
require 'timecop'

RSpec.describe RateLimiter::Storage::Memcache do
  let(:storage) { described_class.new }
  let(:client_id) { '127.0.0.1' }

  before(:all) do
    # Check if Memcached is running
    begin
      Dalli::Client.new.stats
      @memcached_available = true
    rescue Dalli::RingError => e
      @memcached_available = false
      puts "\nWARNING: Memcached is not running. Please start Memcached to run these tests."
    end
  end

  before(:each) do
    skip "Memcached is not available" unless @memcached_available
    storage.instance_variable_get(:@cache).flush rescue nil
  end

  describe '#initialize' do
    it 'creates a Dalli client' do
      expect(storage.instance_variable_get(:@cache)).to be_a(Dalli::Client)
    end
  end

  describe '#add_request' do
    it 'adds a request for a client' do
      storage.add_request(client_id)
      expect(storage.requests_in_last_minute(client_id).size).to eq(1)
    end

    it 'stores timestamps in memcache' do
      storage.add_request(client_id)
      key = "rate_limit:#{client_id}"
      timestamps = storage.instance_variable_get(:@cache).get(key)
      expect(timestamps).to be_an(Array)
      expect(timestamps.size).to eq(1)
    end

    it 'appends new requests to existing ones' do
      3.times { storage.add_request(client_id) }
      expect(storage.requests_in_last_minute(client_id).size).to eq(3)
    end
  end

  describe '#requests_in_last_minute' do
    before do
      3.times { storage.add_request(client_id) }
    end

    it 'returns correct number of requests' do
      expect(storage.requests_in_last_minute(client_id).size).to eq(3)
    end

    it 'returns empty array for unknown client' do
      expect(storage.requests_in_last_minute('unknown_client')).to be_empty
    end

    it 'only returns requests from last minute' do
      # Simulate time passing
      allow(Time).to receive(:now).and_return(Time.now + 61)
      expect(storage.requests_in_last_minute(client_id)).to be_empty
    end
  end

  describe 'multiple clients' do
    let(:client_id_2) { '127.0.0.2' }

    it 'tracks requests separately for different clients' do
      2.times { storage.add_request(client_id) }
      3.times { storage.add_request(client_id_2) }

      expect(storage.requests_in_last_minute(client_id).size).to eq(2)
      expect(storage.requests_in_last_minute(client_id_2).size).to eq(3)
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
