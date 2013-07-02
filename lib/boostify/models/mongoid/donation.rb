module Boostify
  module Models
    module Mongoid
      module Donation
        extend ActiveSupport::Concern

        included do
          include ::Mongoid::Document
          include ::Mongoid::Timestamps

          field :amount, type: Money
          field :commission, type: Money
          field :token, type: String
          index({ token: 1 }, { unique: true })
          index({ donatable_id: 1 }, { unique: true })
        end
      end
    end
  end
end
