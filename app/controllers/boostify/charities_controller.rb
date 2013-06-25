require_dependency 'boostify/application_controller'

module Boostify
  class CharitiesController < ApplicationController

    def index
      @charities = Charity.all
      #TODO need to know user, charity, transaction(amount, commission)
      #TODO no donatable given
      donatable = Boostify.donatable_class.find session[:donatable_id]

      @donation = Donation.new donatable: donatable,
        amount: donatable.donatable_amount,
        commission: donatable.donatable_commission
      #TODO post to formular
    end

    def show
      @charity = Charity.find params[:id]
    end
  end
end
