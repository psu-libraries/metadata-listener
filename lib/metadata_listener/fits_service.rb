# frozen_string_literal: true

require 'http'
require 'nokogiri'

module MetadataListener
  class FitsService
    class FitsError < StandardError; end

    # @param [String] path of file to scan
    # @return [Hash] converted from the xml output
    def self.call(path)
      return {} unless Pathname.new(path).exist?

      endpoint = ENV.fetch('FITS_ENDPOINT', 'http://localhost:8080/fits/examine')
      resp = HTTP.get(endpoint, params: { file: path })
      raise FitsError, Nokogiri::HTML.parse(resp.body.to_s).title unless resp.status < 300

      Hash.from_xml(resp.body.to_s)
    end
  end
end
