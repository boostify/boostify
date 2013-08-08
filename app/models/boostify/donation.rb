module Boostify

  if Boostify.orm == :active_record
    class Donation < ActiveRecord::Base
      include Boostify::Models::ActiveRecord::Donation
    end
  end

  class Donation
    include Boostify::Models::Mongoid::Donation if Boostify.orm == :mongoid
    include ActiveModel::ForbiddenAttributesProtection

    belongs_to :charity, class_name: 'Boostify::Charity'
    belongs_to :donatable, class_name: Boostify.donatable_class.to_s
    belongs_to :user, class_name: Boostify.current_user_class.to_s

    after_save :touch_charity
    before_create :generate_token

    validates :donatable, :commission, presence: true
    validate :charity_id, :lock_charity

    def pixel_url
      [Boostify.tracker_api_endpoint, '?',
       Boostify::Signature.sign(query_params).to_query].join ''
    end

    def self.from_donatable(donatable)
      self.new(
        donatable: donatable,
        amount: donatable.donatable_amount,
        commission: donatable.donatable_commission)
    end

    def to_param
      token
    end

    private

      def query_params
        {
          referal: {
            shop_id: Boostify.partner_id.to_s,
            charity_id: charity_id.to_s
          },
          sale: {
            token: token,
            amount: amount.to_f.to_s,
            commission: commission.to_f.to_s
          }
        }
      end

      def touch_charity
        charity.touch if charity
      end

      def generate_token
        self.token ||= loop do
          random_token = SecureRandom.hex(8)
          break random_token unless Donation.where(token: random_token).exists?
        end
      end

      def lock_charity
        if charity_id_changed? && !charity_id_was.nil?
          errors.add(:charity, 'must not be changed once set')
        end
      end
  end
end
