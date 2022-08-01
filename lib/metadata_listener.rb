# frozen_string_literal: true

module MetadataListener
  require 'metadata_listener/job'
  require 'metadata_listener/redis'
  require 'metadata_listener/report/extracted_text'
  require 'metadata_listener/report/metadata'
  require 'metadata_listener/report/virus'
  require 'metadata_listener/s3_client'
  require 'metadata_listener/service/clamav'
  require 'metadata_listener/service/fits'
  require 'metadata_listener/service/tika'

  class << self
    # @note Because this is intended to run inside a Docker container, it is customary to write logs to STDOUT
    def logger
      @logger ||= Logger.new($stdout)
    end

    def s3_client
      @s3_client ||= S3Client.new
    end
  end
end
