# frozen_string_literal: true

RSpec.describe MetadataListener::ClamavService do
  subject { described_class.call(file) }

  context 'when a virus is not present' do
    let(:file) { fixture_path.join('1.pdf') }

    it { is_expected.to be(false) }
  end

  context 'when a virus is present' do
    let(:file) { fixture_path.join('eicar_com.zip') }

    it { is_expected.to be(true) }
  end

  context 'when the path does not exist' do
    let(:file) { 'nothere' }

    it { is_expected.to be(false) }
  end
end
