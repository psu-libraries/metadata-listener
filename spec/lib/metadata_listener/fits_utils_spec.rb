# frozen_string_literal: true

require 'nokogiri'

RSpec.describe MetadataListener::FitsUtils do
  let(:fits) { described_class.new }

  it 'Returns an valid XML document' do
    xml = fits.scan_servlet(File.expand_path('./spec/files/1.pdf'))
    xml_doc = Nokogiri::XML(xml)
    expect(xml_doc.errors).to be_empty
  end

  # it "extracts words from a Word Document" do
  #     expect(t.extract_text(File.expand_path("./spec/files/1.docx"))).to include("chambray")
  # end

  # it "extracts words from a PowerPoint Document" do
  #     expect(t.extract_text(File.expand_path("./spec/files/1.pptx"))).to include("chambray")
  # end

  # it "extracts metadata from a Word Document" do
  #     expect(t.extract_metadata(File.expand_path("./spec/files/1.docx"))).to include("chambray")
  # end
end

# RSpec.describe Fits do
#     before(:context) do
#         @f = Fits::FitsJob.new
#         ENV['AWS_BUCKET'] = 'scholarsphere'
#         @file_data = {
#             "storage": "cache",
#             "id": "Docker.dmg"
#         }.with_indifferent_access
#         @key = "cache/Docker.dmg"
#         @filename = "/tmp/test"
#     end

#     context "when given a pdf" do
#         it "detects a pdf" do
#             expect(@f.perform(@file_data)).to eq(1)
#         end
#     end

# context "with file " do
#     it "downloads a file" do
#        dl = @s3.download_to_file(@key, @filename)
#        expect(dl.successful?).to be true
#        expect(dl.data['content_type']).to eq("application/pdf")
#     end
# end
# context "without a file" do
#     it "does not return a file" do
#         dl = @s3.download_to_file('cache/nofile', @filname)
#         expect(dl.successful?).to be nil
#     end
# end

# end
