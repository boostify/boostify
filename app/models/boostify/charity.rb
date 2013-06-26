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

    after_touch :update_income!
    after_touch :update_advocates!

    private

      def update_income!
        update_income
        save!
      end

      def update_income
        self.income = calculate_income
      end

      def update_advocates!
        update_advocates
        save!
      end

      def update_advocates
        self.advocates = advocate_count
      end
  end
end
