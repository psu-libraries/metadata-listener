# frozen_string_literal: true

module SpecHelpers
  def fixture_path
    Pathname.pwd.join('spec/files')
  end

  # @return [Hash] Similar to the data returned by Shrine when uploading a file
  # @note Since we're not supporting uploads (yet?) we can access the S3 client via it's private accessor.
  def upload_file(file: sample_file, storage: 'cache')
    client = MetadataListener::S3Client.new.send(:client)
    id = SecureRandom.uuid
    key = [storage, id].join("/")
    file.open do |body|
      client.put_object(bucket: ENV['AWS_BUCKET'], key: key, body: body)
    end
    {id: id, storage: storage}
  end
end

RSpec.configure do |config|
  config.include SpecHelpers
end
