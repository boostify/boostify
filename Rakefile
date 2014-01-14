#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'appraisal'

begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Boostify'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path('../spec/dummy/Rakefile', __FILE__)
load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

require 'rspec/core'
require 'rspec/core/rake_task'

task active_record: 'app:db:test:prepare' do
  ENV['ORM'] = 'active_record'
end

task mongoid: 'app:db:test:prepare' do
  ENV['ORM'] = 'mongoid'
end

desc 'Run tests with Mongoid'
RSpec::Core::RakeTask.new(mongoid_specs: 'mongoid')

desc 'Run tests with ActiveRecord'
RSpec::Core::RakeTask.new(active_record_specs: 'active_record')

desc 'Run all specs'
task spec: [:mongoid_specs, :active_record_specs]

task default: :spec
