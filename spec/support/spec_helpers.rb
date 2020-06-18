# frozen_string_literal: true

module SpecHelpers
  def fixture_path
    Pathname.pwd.join('spec/files')
  end

  # @return [String] path to uploaded file in S3
  # @note Since we're not supporting uploads (yet?) we can access the S3 client via it's private accessor.
  def upload_file(file:)
    client = MetadataListener::S3Client.new.send(:client)
    key = SecureRandom.uuid
    file.open do |body|
      client.put_object(bucket: ENV['AWS_BUCKET'], key: key, body: body)
    end
    key
  end
end

RSpec.configure do |config|
  config.include SpecHelpers
end
