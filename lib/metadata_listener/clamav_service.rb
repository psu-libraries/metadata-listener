# frozen_string_literal: true

require 'clamby'

module MetadataListener
  class ClamavService
    # @param [String, Pathname] filename path of file to scan
    def self.call(filename)
      path = filename.is_a?(String) ? Pathname.new(filename) : filename

      return false unless path.exist?

      Clamby.configure(daemonize: false)
      Clamby.virus?(path.to_s)
    end
  end
end
