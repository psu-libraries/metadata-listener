# frozen_string_literal: true

require 'rufus-scheduler'
require 'clamby'

scheduler = Rufus::Scheduler.new

scheduler.every '2h' do
  puts 'updating av definitions'
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
