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

    def pixel_url
      query_hash = query_params
      query_hash.merge!({ signature: signature(query_hash) })
      [Boostify.tracker_api_endpoint, '?',
       query_hash.to_query].join
    end

    def self.from_donatable(donatable)
      self.new(
        donatable: donatable,
        amount: donatable.donatable_amount,
        commission: donatable.donatable_commission)
    end

    private

      def query_params
        {
          timestamp: Time.now.to_i.to_s,
          referal: {
            shop_id: Boostify.partner_id.to_s
          },
          sale: {
            token: token,
            amount: amount.to_f.to_s,
            commission: commission.to_f.to_s
          }
        }
      end

      def signature(hash)
        OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha256'),
                                Boostify.partner_secret,
                                deep_sort(hash).to_json)
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

      def deep_sort(hash)
        Hash[hash.sort.map { |k, v| [k, v.is_a?(Hash) ? deep_sort(v) : v] }]
      end
  end
end
