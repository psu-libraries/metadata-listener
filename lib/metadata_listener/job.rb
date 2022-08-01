# frozen_string_literal: true

require 'active_job'

module MetadataListener
  class Job < ActiveJob::Base
    queue_as :metadata

    # @param [String] path indicating where the file is stored in S3
    # @param [String] endpoint to send results to
    # @param [String] api_token used to authenticate with endpoint
    # @param [Array<Symbol>] reporting services to run, defaults to []
    def perform(path:, endpoint: nil, api_token: nil, services: [])
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
