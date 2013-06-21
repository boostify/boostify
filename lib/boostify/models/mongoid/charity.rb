module Boostify
  module Models
    module Mongoid
      module Charity
        extend ActiveSupport::Concern

        included do
          include ::Mongoid::Document
          include ::Mongoid::Timestamps

          field :boost_id, type: Integer

          field :title, type: String
          field :name, type: String
          field :url, type: String
          field :short_description, type: String
          field :description, type: String
          field :logo, type: String

          field :advocates, type: Integer
          field :income, type: BigDecimal
        end
      end
    end
  end
end
