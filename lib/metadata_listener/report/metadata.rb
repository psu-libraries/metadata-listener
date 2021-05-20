# frozen_string_literal: true

require 'faraday'

module MetadataListener
  module Report
    class Metadata
      def self.call(**args)
        new(args[:path], args[:endpoint], args[:api_token]).send
      end

      attr_reader :path, :endpoint, :api_token

      def initialize(path, endpoint, api_token)
        @path = path
        @endpoint = endpoint
        @api_token = api_token
      end

      def send
        return unless endpoint.present?

        report_results
      end

      private

        def report_results
          response = connection.put do |req|
            req.body = post_data.to_json
          end
          MetadataListener.logger.warn("Report failed: #{response.body}") unless response.success?
        end

        def post_data
          @post_data ||= begin
                           body = Hash.new
                           body['metadata'] = Service::Fits.call(path)
                           body
                         end
        end

        def connection
          @connection ||= Faraday::Connection.new(
            url: endpoint,
            headers: {
              'Content-Type' => 'application/json',
              'X-API-KEY' => api_token
            },
            ssl: { verify: verify_ssl? }
          )
        end

        def verify_ssl?
          ENV['VERIFY_CLIENT_SSL'] != 'false'
        end
    end
  end
end
