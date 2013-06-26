require_dependency 'boostify/application_controller'

module Boostify
  class CharitiesController < ApplicationController

    before_filter :new_donation_from_session, only: [:index]

    def index
      @charities = Charity.all
    end

    def show
      @charity = Charity.find params[:id]
    end

    private

      def new_donation_from_session
        donatable = Boostify.donatable_class.find session[:donatable_id]
        @donation = Donation.new donatable: donatable,
          amount: donatable.donatable_amount,
          commission: donatable.donatable_commission
      end
  end
end
