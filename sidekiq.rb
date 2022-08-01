# frozen_string_literal: true

$LOAD_PATH.prepend(Pathname.pwd.join('lib').to_s)
require 'sidekiq'
require 'metadata_listener'

::Sidekiq.configure_client do |config|
  config.redis = MetadataListener::Redis.config
end

::Sidekiq.configure_server do |config|
  config.redis = MetadataListener::Redis.config
end

if ENV['DD_AGENT_HOST']
  require 'ddtrace'
  Datadog.configure do |config|
    config.use :sidekiq, {
      analytics_enabled: true,
      service_name: 'scholarsphere-metadata-listener'
    }
    config.use :redis
    config.tracer env: ENV.fetch('DD_ENV', nil)
  end
end
