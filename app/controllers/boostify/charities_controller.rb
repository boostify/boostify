require_dependency 'boostify/application_controller'

module Boostify
  class CharitiesController < ApplicationController

    def index
      @charities = Charity.all
      donatable = Boostify.donatable_class.find session[:donatable_id]

      @donation = Donation.new donatable: donatable,
        amount: donatable.donatable_amount,
        commission: donatable.donatable_commission
    end

    def show
      @charity = Charity.find params[:id]
    end
  end
end
