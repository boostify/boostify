module Boostify
  class ApplicationController < ::ApplicationController
    def get_current_user
      if respond_to?(Boostify.current_user_method)
        send(Boostify.current_user_method)
      end
    end
  end
end
