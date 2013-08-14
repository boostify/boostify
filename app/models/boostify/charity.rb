module Boostify

  if Boostify.orm == :active_record
    class Charity < ActiveRecord::Base
      include Boostify::Models::ActiveRecord::Charity
    end
  end

  class Charity
    include Boostify::Models::Mongoid::Charity if Boostify.orm == :mongoid
    include ActiveModel::ForbiddenAttributesProtection

    has_many :donations, class_name: 'Boostify::Donation',
      primary_key: :boost_id

    validates :boost_id,
      presence: true, uniqueness: true

    validates :title, :name, :url, :short_description, :description, :logo,
      presence: true

    def update_cached_fields!
      calc_income!
      calc_advocates!
      save!
    end

    class << self
      # Find your favorite Charities.
      #
      # Results are sorted by sort_order descending.
      #
      # @return [Array<Charity>] Charities
      def favorites
        sorted_favorites
      end

      # Find a Charity by its boost_id or create a new one with the given
      # attributes.
      #
      # @param attributes [Hash] Charity attributes sufficient to craete a new
      #   valid Charity.
      def find_by_boost_id_or_create(attributes)
        charity = Charity.new(attributes)
        if charity.boost_id
          Charity.where(boost_id: charity.boost_id).first ||
            charity.tap(&:save!)
        end
      end
    end

    private

      def calc_income!
        self.income = calc_income
      end

      def calc_advocates!
        self.advocates = calc_advocates
      end
  end
end
