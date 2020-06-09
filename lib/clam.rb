# frozen_string_literal: true

require 'rufus-scheduler'
require 'clamby'
require_relative '../config/log'

scheduler = Rufus::Scheduler.new
logger = Logger.new(STDOUT)

scheduler.every '2h' do
  logger.info('Updating ClamAV Database')
  Clamby.update
end

class ClamUtils
  def scan(filename)
    Clamby.configure(daemonize: false)
    virus_found = Clamby.virus?(filename)
    return true if virus_found

    false
  end
end
