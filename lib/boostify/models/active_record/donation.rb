module Boostify
  module Models
    module ActiveRecord
      module Donation
        extend ActiveSupport::Concern

        included do
          monetize :amount_cents, with_currency: Boostify::CURRENCY
          monetize :commission_cents, with_currency: Boostify::CURRENCY

          attr_accessible :amount, :commission, :charity_id, :donatable_id,
            :charity, :donatable, :status
        end
      end
    end
  end
end
