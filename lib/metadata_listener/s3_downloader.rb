# frozen_string_literal: true

require 'aws-sdk-s3'
require 'fileutils'

module MetadataListener
  class S3Downloader
    def initialize
      return unless s3_options[:access_key_id].present?

      Aws.config.update(s3_options)
    end

    def download_to_file(key, filename)
      s3 = Aws::S3::Client.new
      File.open(filename, 'wb') do |file|
        return s3.get_object({ bucket: bucket, key: key }, target: file)
      end
    end

    private

      def bucket
        @bucket ||= ENV.fetch('AWS_BUCKET')
      end

      def s3_options
        @s3_options ||= if ENV.key?('S3_ENDPOINT')
                          base_options.merge(endpoint: ENV['S3_ENDPOINT'], force_path_style: true)
                        else
                          base_options
                        end
      end

      def base_options
        {
          access_key_id: ENV['AWS_ACCESS_KEY_ID'],
          secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
          region: ENV['AWS_REGION']
        }
      end
  end
end
