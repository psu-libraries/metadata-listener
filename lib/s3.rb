# frozen_string_literal: true

require 'aws-sdk-s3'
require 'fileutils'

class S3Downloader
  def initialize
    @bucket = ENV.fetch('AWS_BUCKET')
    s3_options = {
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: ENV['AWS_REGION']
    }
    s3_options = s3_options.merge(endpoint: ENV['S3_ENDPOINT'], force_path_style: true) if ENV.key?('S3_ENDPOINT')
    Aws.config.update(s3_options)
  end

  def download_to_file(key, filename)
    s3 = Aws::S3::Client.new
    File.open(filename, 'wb') do |file|
      return s3.get_object({ bucket: @bucket, key: key }, target: file)
    end
  end
end
