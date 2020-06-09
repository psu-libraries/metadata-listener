# frozen_string_literal: true

require_relative '../lib/clam'

RSpec.describe ClamUtils do
  let(:clam) { described_class.new }

  it 'Returns no Virus' do
    virus = clam.scan(File.expand_path('./spec/files/1.pdf'))
    expect(virus).to be false
  end
  it 'Rerturns a Virus' do
    virus = clam.scan(File.expand_path('./spec/files/eicar_com.zip'))
    expect(virus).to be true
  end
end