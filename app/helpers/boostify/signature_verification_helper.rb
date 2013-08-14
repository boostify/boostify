module Boostify
  module SignatureVerificationHelper

    def verify_signature!
      HMACAuth::Signature.verify(params, secret: Boostify.partner_secret) ||
        head(:unprocessable_entity)
    end

  end
end
