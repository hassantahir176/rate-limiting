# frozen_string_literal: true

require_relative "lib/rate_limiter/version"

Gem::Specification.new do |spec|
  spec.name = "rack_rate_limiting"
  spec.version = RateLimiter::VERSION
  spec.authors = ["Hassan Tahir"]
  spec.email = ["hassantahirjaura@gmail.com"]

  spec.summary = "Use this gem to rate limit your API requests."
  spec.description = "This gem provides a simple and flexible rate limiting mechanism for Rack applications. It allows you to control the rate at which requests are processed, preventing abuse and ensuring fair usage."
  #TODO: Use same name as the gem
  spec.homepage = "https://github.com/hassantahir176/rate-limiting"
  spec.metadata = {
    "homepage_uri" => "https://github.com/hassantahir176/rate-limiting"
  }
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Specify the latest versions below
  spec.add_dependency "rack", "~> 2.0"
  spec.add_dependency "redis", "~> 4.0"
  spec.add_dependency "dalli", "~> 3.0"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "timecop", "~> 0.9.0"
  spec.add_development_dependency "byebug"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
