require_dependency 'boostify/application_controller'

module Boostify
  class CharitiesController < ApplicationController

    def index
      @charities = Charity.all
    end

    def show
      @charity = Charity.find params[:id]
    end
  end
end
