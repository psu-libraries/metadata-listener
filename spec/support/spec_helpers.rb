# frozen_string_literal: true

module SpecHelpers
  def fixture_path
    Pathname.pwd.join('spec/files')
  end

  # @note Since we're not supporting uploads (yet?) we can access the S3 client via it's private accessor.
  def upload_file(sample_file)
    client = MetadataListener::S3Client.new.send(:client)
    key = SecureRandom.uuid
    uploaded_file = sample_file.open do |file|
      client.put_object(bucket: ENV['AWS_BUCKET'], key: key, body: file)
    end
    key
  end
end

RSpec.configure do |config|
  config.include SpecHelpers
end
