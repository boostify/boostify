module Boostify
  module Models
    module Mongoid
      module Donation
        extend ActiveSupport::Concern

        included do
          include ::Mongoid::Document
          include ::Mongoid::Timestamps
        end
      end
    end
  end
end
