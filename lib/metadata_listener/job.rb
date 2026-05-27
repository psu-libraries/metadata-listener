# frozen_string_literal: true

require 'sidekiq'
require 'active_support/all'

module MetadataListener
  class Job
    include Sidekiq::Job

    sidekiq_options queue: :metadata

    # @param [Hash] payload JSON-serializable payload from Sidekiq
    def perform(payload)
      path = payload.fetch('path')
      endpoint, api_token, services = payload.values_at('endpoint', 'api_token', 'services')
      services = Array(services).map(&:to_sym)

      file = MetadataListener.s3_client.download_file(path)
      services << :virus if services.empty?

      services.map do |key|
        report(key).call(path: file.body.path, endpoint:, api_token:)
      end

      FileUtils.rm_f(file.body.path)
    end

    private

      def report(key)
        case key
        when :metadata
          MetadataListener::Report::Metadata
        else
          MetadataListener::Report.const_get(key.to_s.classify)
        end
      end
  end
end
