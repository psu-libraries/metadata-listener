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
        @text ||= rta.to_text.gsub(/\n+/, ' ')
      end

      def metadata
        Hash[elements.map { |element| element.split(': ') }]
      end

      private

        def elements
          @elements ||= rta.to_metadata.split("\n")
        end
    end
  end
end
