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
          field :cover, type: String

          field :advocates, type: Integer, default: 0
          field :income, type: Money, default: Money.new(0, Boostify::CURRENCY)

          field :sort_order, type: Integer

          index({ boost_id: 1, _id: 1 })
          index({ boost_id: 1, sort_order: -1, created_at: -1 })
        end

        module ClassMethods

          private

            # Find favorite charities sorted by sort_order desc, created_at
            # desc.
            def sorted_favorites
              scoped.
                in(boost_id: Boostify.favorite_charity_ids).
                desc(:sort_order).desc(:created_at)
            end
        end

        private

          def calc_advocates
            donations.distinct(:user_id).count
          end

          def calc_income
            Money.new donations.sum(:'commission.cents'), Boostify::CURRENCY
          end
      end
    end
  end
end
