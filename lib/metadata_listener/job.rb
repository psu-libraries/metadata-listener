# frozen_string_literal: true

require 'active_job'

module MetadataListener
  class Job < ActiveJob::Base
    def initialize
      @tmpdir = ENV.fetch('TMPDIR', '/tmp')
      @s3 = S3Downloader.new
      @fits = FitsUtils.new
      @tika = Tika.new
    end

    def perform(file_data)
      key = "#{file_data['storage']}/#{file_data['id']}"
      filename = "#{@tmpdir}/#{Digest::MD5.hexdigest(key)}"

      logger.info("Downloading file to #{filename}")
      @s3.download_to_file(key, filename)

      logger.info('Running tika')
      extracted_text = @tika.extract_text(filename)

      puts extracted_text

      logger.info('Running FITS')
      fits_xml = @fits.scan_servlet(filename)
      puts fits_xml

      logger.info('removing temp file')
      File.delete(filename)
    end
  end
end
