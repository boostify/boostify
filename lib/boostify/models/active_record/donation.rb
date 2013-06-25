module Boostify
  module Models
    module ActiveRecord
      module Donation
        extend ActiveSupport::Concern

        included do
          monetize :amount_cents, with_currency: Boostify::CURRENCY
          monetize :commission_cents, with_currency: Boostify::CURRENCY
        end
      end
    end
  end
end
