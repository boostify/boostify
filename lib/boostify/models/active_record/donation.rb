module Boostify
  module Models
    module ActiveRecord
      module Donation
        extend ActiveSupport::Concern

        included do
          monetize :amount_cents, with_currency: Boostify::CURRENCY,
            allow_nil: true
          monetize :commission_cents, with_currency: Boostify::CURRENCY,
            allow_nil: true
        end

        def commission_changed?
          commission_cents_changed? || commission_currency_changed?
        end
      end
    end
  end
end
