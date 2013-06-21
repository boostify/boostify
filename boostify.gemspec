$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'boostify/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'boostify'
  s.version     = Boostify::VERSION
  s.authors     = ['Frank C. Eckert', 'Gebhard Wöstemeyer', 'Sebastian Schasse']
  s.email       = ['frank.eckert@boost-project.com']
  s.homepage    = 'http://github.com/opahk/boostify'
  s.summary     = 'Boostify your application!'
  s.description = 'Boostify your application!'

  s.files = Dir["{app,config,db,lib}/**/*"] +
    ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'rails', '~> 3.2.12'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rails_best_practices'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'mongoid'
  s.add_development_dependency 'fabrication'
end
