# frozen_string_literal: true

require 'thread'
require 'dalli'
require_relative 'rate_limiter/version'
require_relative 'rate_limiter/configuration'
require_relative 'rate_limiter/storage/base'
require_relative 'rate_limiter/storage/memory'
require_relative 'rate_limiter/storage/memcache'
require_relative 'rate_limiter/storage/redis'
require_relative 'rate_limiter/storage/factory'
require_relative 'rate_limiter/middleware'

module RateLimiter
  class Error < StandardError; end

  def self.configure
    @config ||= Configuration.new
    yield(@config) if block_given?
  end

  def self.config
    @config
  end

  def self.storage
    @storage ||= Storage::Factory.create(config)
  end
end
