# frozen_string_literal: true

require 'http'

class FitsUtils
  def scan_servlet(filename)
    resp = HTTP.get('http://localhost:8080/fits/examine', params: { file: filename })
    resp.body.to_str
  end
end
