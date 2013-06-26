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

    def pixel_url
      query_hash = query_params
      query_hash.merge!({ signature: signature(query_hash) })
      [Boostify.tracker_api_endpoint, '?',
       query_hash.to_query].join
    end

    private

      def query_params
        #TODO make this not hard coded (soft coded)
        {
          timestamp: Time.now.to_i,
          referal: {
            shop_id: Boostify.partner_id
          },
          sale: {
            token: 'asdfASDF',
            amount: 1.34,
            commission: 1.34
          }
        }
      end

      def signature(hash)
        OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha256'),
                                Boostify.partner_secret,
                                hash.sort.to_json)
      end

      def touch_charity
        charity.touch if charity
      end
  end
end
