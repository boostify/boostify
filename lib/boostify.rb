require "boostify/engine"

module Boostify

  # set client secret
  mattr_accessor :secret_key

  # set charity api endpoint
  mattr_accessor :charity_api_endpoint
  @@charity_api_endpoint = 'https://www.boost-project.com/de/charities/'

  # set tracker api endpoint
  mattr_accessor :tracker_api_endpoint
  @@tracker_api_endpoint = 'https://www.boost-project.com/de/tracker/'

  def self.config
    yield self
  end
end
