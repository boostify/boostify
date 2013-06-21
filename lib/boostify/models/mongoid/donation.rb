module Boostify
  module Models
    module Mongoid
      module Donation
        extend ActiveSupport::Concern

        included do
          include ::Mongoid::Document
          include ::Mongoid::Timestamps

          belongs_to :charity
          belongs_to :donatable
        end
      end
    end
  end
end
