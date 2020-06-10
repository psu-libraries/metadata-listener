# frozen_string_literal: true

RSpec.describe MetadataListener::Job do
  it do
    skip 'Minio instance required for testing'
    expect(described_class.new).to be_an(ActiveJob::Base)
  end
end
