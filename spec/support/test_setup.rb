# frozen_string_literal: true

class TestSetup
  def self.prepare
    new.clean_minio
  end

  attr_reader :client, :bucket

  def initialize
    s3 = MetadataListener::S3Client.new
    @client = s3.send(:client)
    @bucket = s3.send(:bucket)
  end

  def clean_minio
    client.list_objects(bucket: bucket).contents.map(&:key).map do |key|
      client.delete_object(key: key, bucket: bucket)
    end
  rescue Aws::S3::Errors::NoSuchBucket
    client.create_bucket(bucket: bucket)
  end
end

RSpec.configure do |config|
  config.before :suite do
    TestSetup.prepare
  end
end
