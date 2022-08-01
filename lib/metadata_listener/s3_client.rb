# frozen_string_literal: true

require 'aws-sdk-s3'

module MetadataListener
  class S3Client
    def initialize
      raise ArgumentError, 'S3 configuration is missing required options' unless valid?

      Aws.config.update(s3_options)
    end

    # @param [String] key
    # @return [Seahorse::Client::Response]
    def download_file(key)
      client.get_object(bucket:, key:, response_target: Tempfile.new)
    end

    # @param [Pathname, File, IO] file
    # @return [String] path to the uploaded file in the bucket
    def upload_file(file:, store: ENV.fetch('CACHE_PREFIX', 'cache'))
      source = Pathname.new(file)
      key = "#{store}/#{SecureRandom.uuid.gsub(/-/, '')}#{source.extname}"

      source.open do |body|
        client.put_object(bucket:, key:, body:)
      end
      key
    end

    private

      def valid?
        bucket.present? && s3_options.none? { |_key, value| value.nil? }
      end

      def client
        @client ||= Aws::S3::Client.new
      end

      def bucket
        @bucket ||= ENV.fetch('AWS_BUCKET', nil)
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
          access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID', nil),
          secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY', nil),
          region: ENV.fetch('AWS_REGION', 'us-east-1')
        }
      end
  end
end
