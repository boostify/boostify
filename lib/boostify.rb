require 'mongoid'
require 'faraday'
require 'boostify/engine'

require 'boostify/models/donatable'
require 'boostify/models/mongoid/charity'
require 'boostify/models/mongoid/donation'
require 'boostify/jobs/sync_charities'

require 'haml'

module Boostify
  mattr_accessor :api_endpoint
  self.api_endpoint = 'https://www.boost-project.com/network'

  # set partner id
  mattr_accessor :partner_id

  # set partner secret
  mattr_accessor :partner_secret

  # set tracker api endpoint
  mattr_accessor :tracker_api_endpoint
  @@tracker_api_endpoint = 'https://www.boost-project.com/de/tracker/both.png'

  mattr_accessor :orm
  @@orm = :mongoid

  mattr_accessor :donatable_class
  self.donatable_class = 'Transaction'

  mattr_accessor :favorite_charities
  self.favorite_charities = [1, 44]

  def self.config
    yield self
  end

  def self.donatable_class
    @@donatable_class.constantize
  end

  def self.charity_api_endpoint
    "#{Boostify.api_endpoint}/shops/#{Boostify.partner_id}/charities"
  end
end
