# frozen_string_literal: true

$LOAD_PATH.prepend(Pathname.pwd.join('lib').to_s)
require 'sidekiq'
require 'metadata_listener'

Sidekiq.configure_client do |config|
  config.redis = MetadataListener::Redis.config
end

Sidekiq.configure_server do |config|
  config.redis = MetadataListener::Redis.config
end
