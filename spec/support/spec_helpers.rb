# frozen_string_literal: true

module SpecHelpers
  def fixture_path
    Pathname.pwd.join('spec/fixtures')
  end
end

RSpec.configure do |config|
  config.include SpecHelpers
end
