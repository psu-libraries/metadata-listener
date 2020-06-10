# frozen_string_literal: true

module MetadataListener
  class Redis
    class << self
      def config
        {
          url: redis_url,
          password: redis_password
        }.reject { |_key, value| value.empty? }
      end

      private

        def redis_password
          ENV.fetch('REDIS_PASSWORD', '')
        end

        def redis_host
          ENV.fetch('REDIS_HOST', 'localhost')
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
    end
  end
end
