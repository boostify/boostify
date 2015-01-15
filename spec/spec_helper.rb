require 'simplecov'
require 'coveralls'
require 'database_cleaner'
require 'pry'
require 'webmock/rspec'
require 'timecop'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter '/spec/'
end

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../dummy/config/environment.rb', __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'fabrication'
require 'faker'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'

  # DatabaseCleaner
  config.before(:suite) do
    DatabaseCleaner[:active_record].strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner[:active_record].start
    @routes = Boostify::Engine.routes
    Mongoid.purge!
  end

  config.after(:each) do
    DatabaseCleaner[:active_record].clean
  end
end
