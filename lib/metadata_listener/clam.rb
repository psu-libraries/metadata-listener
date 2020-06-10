# frozen_string_literal: true

require 'clamby'

module MetadataListener
  class ClamUtils
    def scan(filename)
      Clamby.configure(daemonize: false)
      virus_found = Clamby.virus?(filename)
      return true if virus_found

      false
    end
  end
end
