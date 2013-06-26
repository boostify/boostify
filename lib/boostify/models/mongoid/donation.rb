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
        end
      end
    end
  end
end
