require_dependency 'boostify/application_controller'

module Boostify
  class CharitiesController < ApplicationController

    before_filter :build_donation

    def index
      @charities = Charity.favorites
    end

    def show
      @charity = Charity.find params[:id]
    end

    private

      def build_donation
        if params[:donatable_id]
          donatable = Boostify.donatable_class.find params[:donatable_id]
          @donation = Donation.from_donatable donatable
        end
      end
  end
end
