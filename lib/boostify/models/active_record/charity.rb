module Boostify
  module Models
    module ActiveRecord
      module Charity
        extend ActiveSupport::Concern

        included do
          monetize :income_cents, with_currency: Boostify::CURRENCY
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

          def calc_advocates
            donations.count(:user_id, distinct: true)
          end

          def calc_income
            Money.new donations.sum(:commission_cents), Boostify::CURRENCY
          end
      end
    end
  end
end
