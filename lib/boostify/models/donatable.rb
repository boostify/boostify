module Boostify
  module Models
    module Donatable
      extend ActiveSupport::Concern

      included do
        has_one :boostify_donation, class_name: 'Boostify::Donation'
      end
    end
  end
end
