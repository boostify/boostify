module Boostify
  class Signature

    def initialize(params)
      @_params = params
    end

    def verify
      valid_timestamp && signature == calculated_signature
    end

    # @return [Hash] Signed parameters
    def sign
      timestamp || params['timestamp'] = Time.now.to_i.to_s
      params.merge('signature' => calculated_signature)
    end

    class << self
      def verify(params)
        self.new(params).verify
      end

      def sign(params)
        self.new(params).sign
      end
    end

    private

      def calculated_signature
        OpenSSL::HMAC.hexdigest(
          OpenSSL::Digest::Digest.new('sha256'),
          Boostify.partner_secret,
          deep_sort(params_without_signature).to_json)
      end

      def deep_sort(hash)
        Hash[hash.sort.map { |k, v| [k, v.is_a?(Hash) ? deep_sort(v) : v] }]
      end

      def deep_stringify(hash)
        Hash[hash.map do |k, v|
          [k.to_s, v.is_a?(Hash) ? deep_stringify(v) : v.to_s]
        end]
      end

      def valid_timestamp
        timestamp && timestamp >= 15.minutes.ago.to_i
      end

      def timestamp
        params['timestamp'].present? &&
          params['timestamp'].to_s =~ /\A\d+\Z/ &&
          params['timestamp'].to_i
      end

      def signature
        params['signature']
      end

      def params_without_signature
        params.reject { |k, v| k == 'signature' }
      end

      def params
        @params ||= deep_stringify(@_params.reject do |k, v|
          %w(action controller format).include? k
        end)
      end
  end
end
