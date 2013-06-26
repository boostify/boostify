module Boostify

  if Boostify.orm == :active_record
    class Charity < ActiveRecord::Base
      include Boostify::Models::ActiveRecord::Charity
    end
  end

  class Charity
    include Boostify::Models::Mongoid::Charity if Boostify.orm == :mongoid
    include ActiveModel::ForbiddenAttributesProtection

    has_many :donations, class_name: 'Boostify::Donation'

    after_touch :recalculate_cached_fields!

    private

      def recalculate_cached_fields!
        update_attributes!(
          income: calculate_income,
          advocates: advocate_count)
      end
  end
end
