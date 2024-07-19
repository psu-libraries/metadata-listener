# frozen_string_literal: true

$LOAD_PATH.prepend(Pathname.pwd.join('lib').to_s)
require 'sidekiq'
require 'metadata_listener'
require 'bugsnag'

Bugsnag.configure do |config|
  config.app_version = ENV.fetch('APP_VERSION', nil)
  config.release_stage = ENV.fetch('BUGSNAG_RELEASE_STAGE', 'development')
end

Sidekiq.configure_client do |config|
  config.redis = MetadataListener::Redis.config
end

Sidekiq.configure_server do |config|
  config.redis = MetadataListener::Redis.config
end
