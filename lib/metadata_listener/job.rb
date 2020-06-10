# frozen_string_literal: true

require 'active_job'

module MetadataListener
  class Job < ActiveJob::Base
    queue_as :metadata

    #def initialize
    #  #@tmpdir = ENV.fetch('TMPDIR', '/tmp')
    #  #@s3 = S3Downloader.new
    #  #@fits = FitsUtils.new
    #  @tika = Tika.new
    #end

    def perform(file_data)
      puts "Performing #{file_data}"
    end
  end
end
