module Boostify
  module SignatureVerificationHelper

    def verify_signature!
      Signature.verify(params) || head(:unprocessable_entity)
    end

  end
end
