$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'boostify/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'boostify'
  s.version     = Boostify::VERSION
  s.authors     = ['Frank C. Eckert']
  s.email       = ['frank.eckert@boost-project.com']
  s.homepage    = 'http://github.com/opahk/boostify'
  s.summary     = "TODO: Summary of Boostify."
  s.description = "TODO: Description of Boostify."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency 'rails', '~> 3.2.12'
  # s.add_dependency "jquery-rails"

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
end
