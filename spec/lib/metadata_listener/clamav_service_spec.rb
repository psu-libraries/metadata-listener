# frozen_string_literal: true

RSpec.describe MetadataListener::ClamavService do
  subject { described_class.call(path) }

  context 'when a virus is not present' do
    let(:path) { fixture_path.join('1.pdf').to_s }

    it { is_expected.to be(false) }
  end

  context 'when a virus is present' do
    let(:path) { fixture_path.join('eicar_com.zip').to_s }

    it { is_expected.to be(true) }
  end

  context 'when the path does not exist' do
    let(:path) { 'nothere' }

    it { is_expected.to be(false) }
  end
end
