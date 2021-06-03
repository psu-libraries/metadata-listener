# frozen_string_literal: true

require 'ruby_tika_app'

module MetadataListener
  module Service
    class Tika
      attr_reader :rta

      # @param [String] path of file to scan
      def initialize(path)
        @rta = RubyTikaApp.new(path)
      end

      def text
        return cleaned_text if cleaned_text.encoding.name == 'UTF-8'

        MetadataListener.logger.warn('Text is not UTF-8 and cannot be used')
        ''
      end

      def metadata
        Hash[elements.map { |element| element.split(': ') }]
      end

      private

        def cleaned_text
          @cleaned_text ||= rta.to_text.gsub(/\n+/, ' ')
        end

        def elements
          @elements ||= rta.to_metadata.split("\n")
        end
    end
  end
end
