# frozen_string_literal: true

require 'faraday'

module MetadataListener
  module Report
    class ExtractedText
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
        if text_file.empty?
          MetadataListener.logger.info('No text found in file')
        elsif response.success?
          MetadataListener.logger.info('Text extracted successfully')
        else
          MetadataListener.logger.warn("Text extraction failed: #{response.body}")
        end
      end

      private

        def response
          @response ||= connection.put do |req|
            req.body = { derivatives: { text: params } }.to_json
          end
        end

        def params
          {
            id: uploaded_file.split('/').last,
            storage: uploaded_file.split('/').first,
            metadata: {
              size: text_file.size,
              filename: text_file.basename,
              mime_type: 'text/plain'
            }
          }
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

        def uploaded_file
          @uploaded_file ||= MetadataListener.s3_client.upload_file(file: text_file, store: 'derivatives')
        end

        def text_file
          @text_file ||= begin
            file = Tempfile.new(['', '.txt'])
            file.binmode
            file.write(Service::Tika.new(path).text)
            file.close
            Pathname.new(file)
          end
        end

        def verify_ssl?
          ENV['VERIFY_CLIENT_SSL'] != 'false'
        end
    end
  end
end
