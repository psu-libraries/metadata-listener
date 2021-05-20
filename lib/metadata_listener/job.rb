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
        available_reports[key].call(path: file.body.path, endpoint: endpoint, api_token: api_token)
      end

      FileUtils.rm_f(file.body.path)
    end

    private

      def available_reports
        {
          virus: Report::Virus,
          metadata: Report::Metadata
        }
      end
  end
end
