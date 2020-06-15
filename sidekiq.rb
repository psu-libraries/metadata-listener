# frozen_string_literal: true

require 'sidekiq'
Dir[Pathname.pwd.join('lib', 'metadata_listener', '**', '*.rb')].sort.each { |f| require f }

::Sidekiq.configure_client do |config|
  config.redis = MetadataListener::Redis.config
end

::Sidekiq.configure_server do |config|
  config.redis = MetadataListener::Redis.config
end

if ENV['DD_AGENT_HOST']
  require 'ddtrace'
  Datadog.configure do |c|
    c.use :sidekiq, { analytics_enabled: true,
                      service_name: 'scholarsphere-metadata-listener' }
    c.use :redis
    c.tracer env: ENV['DD_ENV']
  end
end
