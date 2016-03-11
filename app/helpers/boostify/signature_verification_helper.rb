module Boostify
  module SignatureVerificationHelper

    def partner_secret
      if Boostify.partner_secret.respond_to? :call
        Boostify.partner_secret.call
      else
        Boostify.partner_secret
      end
    end

    def verify_signature!
      HMACAuth::Signature.verify(params, secret: partner_secret) ||
        head(:unprocessable_entity)
    end

  end
end
