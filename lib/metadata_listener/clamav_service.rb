# frozen_string_literal: true

require 'clamby'

module MetadataListener
  class ClamavService
    # @param [String] path of file to scan
    def self.call(path)
      return false unless Pathname.new(path).exist?

      Clamby.configure(daemonize: false)
      Clamby.virus?(path)
    end
  end
end
