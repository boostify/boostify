module Boostify
  class Engine < ::Rails::Engine
    isolate_namespace Boostify

    config.generators do |g|
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :fabrication
      g.assets false
      g.helper false
    end
  end
end
