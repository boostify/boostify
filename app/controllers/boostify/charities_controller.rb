require_dependency 'boostify/application_controller'

module Boostify
  class CharitiesController < ApplicationController

    before_filter :new_donation_from_session, only: [:index, :show]

    def index
      @charities = Charity.favorites
    end

    def show
      @charity = Charity.find params[:id]
    end

    private

      def new_donation_from_session
        if session[:donatable_id]
          donatable = Boostify.donatable_class.find session[:donatable_id]
          @donation = Donation.from_donatable donatable
        end
      end
  end
end
