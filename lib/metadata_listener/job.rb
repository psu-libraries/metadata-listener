# frozen_string_literal: true

require 'active_job'

module MetadataListener
  class Job < ActiveJob::Base
    queue_as :metadata

    # @param [String] path indicating where the file is stored in S3
    # @option [String] endpoint to send results to
    # @option [String] api_token used to authenticate with endpoint
    def perform(path:, endpoint: nil, api_token: nil)
      file = MetadataListener.s3_client.download_file(path)
      VirusReportingService.call(path: file.body.path, endpoint: endpoint, api_token: api_token)
    end
  end
end
