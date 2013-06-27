module Boostify
  module Jobs
    class SyncCharities

      def self.perform
        Boostify.favorite_charity_ids.each do |charity_id|
          update_or_create_charity charity_id
        end
      end

      private

        def self.update_or_create_charity(charity_id)
          charity = Boostify::Charity.
            where(boost_id: charity_id).first_or_initialize
          charity.update_attributes! params(charity_id)
        end

        def self.params(charity_id)
          params = JSON.parse(download(charity_id))['charity']
          params['boost_id'] = params['id']
          params
        end

        def self.download(charity_id)
          response = connection.get charity_url(charity_id)
          unless response.success?
            raise "Failed to download Charity with ID=#{charity_id}!\n" <<
              "#{response.inspect}"
          end
          response.body
        end

        def self.charity_url(charity_id)
          "#{Boostify.charity_api_endpoint}/#{charity_id}.json"
        end

        def self.connection
          con = Faraday.new(ssl: { verify: Boostify.ssl_verify })
          con.basic_auth(ENV['BOOSTIFY_USER'], ENV['BOOSTIFY_PASSWORD'])
          con
        end
    end
  end
end
