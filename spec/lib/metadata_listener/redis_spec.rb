# frozen_string_literal: true

RSpec.describe MetadataListener::Redis do
  describe '::config' do
    subject { described_class.config }

    let(:host) { ENV.fetch('REDIS_HOST', 'localhost') }

    it { is_expected.to include(url: "redis://#{host}:6379/0") }
  end
end
