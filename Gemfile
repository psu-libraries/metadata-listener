# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'activejob', '~> 6.0'
gem 'aws-sdk-s3', '~> 1.60'
gem 'bugsnag'
gem 'clamby', '~> 1.6'
gem 'faraday'
gem 'http'
gem 'ruby_tika_app', git: 'https://github.com/psu-libraries/ruby_tika_app.git', branch: 'tika-2.4.1'
gem 'sidekiq', '~> 7.0'

# Development gems
# Since this isn't a Rails app, there really isn't a functional way to distinguish between dev/test gems and the gems
# used when this is run in production, so we're just going to list them out here:

gem 'guard', '~> 2.16'
gem 'guard-rspec', '~> 4.7'
gem 'mutex_m', '~> 0.3'
gem 'niftany', '~> 0.10'
gem 'pry'
gem 'rspec', '~> 3.9'
gem 'rspec-its', '~> 1.3'
gem 'simplecov', '0.17.1', require: false
gem 'vcr', require: false
gem 'webmock', require: false

gem 'rubocop'
