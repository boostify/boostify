module Boostify
  module Models
    module Donatable
      extend ActiveSupport::Concern

      included do
        has_one :boostify_donation, class_name: 'Boostify::Donation',
          inverse_of: :donatable
      end

      mattr_accessor :amount_method
      mattr_accessor :commission_method

      def donatable_amount
        self.send(@@amount_method)
      end

      def donatable_commission
        self.send(@@commission_method)
      end

      module ClassMethods

        def donatable_amount(amount_method)
          Boostify::Models::Donatable.amount_method = amount_method
        end

        def donatable_commission(commission_method)
          Boostify::Models::Donatable.commission_method = commission_method
        end
      end
    end
  end
end
