# frozen_string_literal: true

class FitsConfig
  def initialize
    redis_config = {
      url: redis_url,
      password: redis_password
    }
    Sidekiq.configure_client do |config|
      config.redis = redis_config
    end

    Sidekiq.configure_server do |config|
      config.redis = redis_config
    end
  end

  def redis_password
    ENV.fetch('REDIS_PASSWORD', nil)
  end

  def redis_host
    ENV.fetch('REDIS_HOST', '127.0.0.1')
  end

  def redis_port
    ENV.fetch('REDIS_PORT', 6379)
  end

  def redis_database
    ENV.fetch('REDIS_DATABASE', 0)
  end

  def redis_url
    "redis://#{redis_host}:#{redis_port}/#{redis_database}"
  end

  if ENV['DD_AGENT_HOST']
    require 'ddtrace'
    Datadog.configure do |c|
      c.use :sidekiq, { analytics_enabled: true,
                        service_name: 'scholarsphere-metadata-listener' }
      c.use :redis
      c.tracer env: ENV.fetch('DD_ENV', nil)
    end
  end
end
