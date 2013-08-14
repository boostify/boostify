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

          attr_accessible :amount, :commission, :charity_id, :donatable_id,
            :charity, :donatable, :status, :user, :user_id, :token
        end

        def commission_changed?
          commission_cents_changed? || commission_currency_changed?
        end
      end
    end
  end
end
