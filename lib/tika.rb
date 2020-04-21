# frozen_string_literal: true
require 'ruby_tika_app'

class Tika
    def extract_text(filename)
        rta = RubyTikaApp.new(filename)
        rta.to_text.gsub(/\n+/, ' ')
    end
    
    def extract_metadata(filename)
        metadata = {}
        rta = RubyTikaApp.new(filename)
        rta.to_metadata.split("\n").each do |line|
            this_obj = {}
            things = line.reverse.split(":", 2).map(&:reverse).reverse
            this_obj[things[0]] = things[1]
            metadata.merge!(this_obj)
            # puts line.split(":", 2)
        end
        puts metadata
    end

end
