require 'mongoid'

require 'boostify/engine'
require 'boostify/models/charitable'
require 'boostify/models/donatable'

require 'boostify/models/mongoid/charity'

module Boostify

  # set partner id
  mattr_accessor :partner_id

  # set partner secret
  mattr_accessor :partner_secret

  # set charity api endpoint
  mattr_accessor :charity_api_endpoint
  @@charity_api_endpoint = 'https://www.boost-project.com/de/charities/'

  # set tracker api endpoint
  mattr_accessor :tracker_api_endpoint
  @@tracker_api_endpoint = 'https://www.boost-project.com/de/tracker/both.png'

  mattr_accessor :orm
  @@orm = :mongoid

  def self.config
    yield self
  end
end
