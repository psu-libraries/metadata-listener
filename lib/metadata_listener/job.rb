# frozen_string_literal: true

require 'active_job'

module MetadataListener
  class Job < ActiveJob::Base
    queue_as :metadata

    # @param [Hash] file_data from Shrine indicating where the file is stored in S3
    # @example { "file_data": { "id": "c05689eaa917d4982f7e94bd71c8f83e.png", "storage": "cache" } }
    def perform(**args)
      file_data = HashWithIndifferentAccess.new(args.fetch(:file_data))
      raise ArgumentError, 'file_data must have an id' unless file_data.key?(:id)

      file = s3_client.download_file("#{file_data['storage']}/#{file_data['id']}")

      # @todo For now, we'll just call the service until we decide what to do with the result
      ClamavService.call(file.body.path)
    end

    private

      def s3_client
        @s3_client ||= S3Client.new
      end
  end
end
