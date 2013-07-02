module Boostify
  module Models
    module ActiveRecord
      module Charity
        extend ActiveSupport::Concern

        included do
          monetize :income_cents, with_currency: Boostify::CURRENCY

          attr_accessible :title, :name, :url, :short_description, :logo,
            :advocates, :income, :boost_id, :description, :income, :sort_order,
            :cover
        end

        module ClassMethods

          private

            def sorted_favorites
              scoped.
                where(boost_id: Boostify.favorite_charity_ids).
                order('sort_order DESC, created_at DESC')
            end
        end

        private

          def advocate_count
            donations.count(:user_id, distinct: true)
          end

          def calculate_income
            Money.new donations.sum(:commission_cents), Boostify::CURRENCY
          end
      end
    end
  end
end
