module Boostify
  class DonationsController < ApplicationController

    def new
      session[:donatable_id] = params[:id]
      redirect_to charities_path
    end

    # in params complete donation needed (with charity, amount, etc.)
    # in session donatable_id needed
    def create
      @donation = Donation.new(donation_params)
      if @donation.save
        after_donation_creation @donation
        session[:donatable_id] = nil
        redirect_to donation_path(@donation), notice: pixel_img
      else
        redirect_to charities_path
      end
    end

    def show
      @donation = Donation.find params[:id]
      #TODO redirect to boost, if no charity given
    end

    private

      def donation_params
        params.require(:donation).permit(:amount, :commission, :charity_id)
          .merge(donatable_id: session[:donatable_id], user: get_current_user)
      end

      def after_donation_creation(donation)
        #TODO create a transaction to the donation
        # do not forget to do some validations
        # (p.e. user is allowed to create a transaction)
        if defined?(super)
          super donation
        end
      end

      def pixel_img
        src = @donation.pixel_url
        render_to_string(partial: 'pixel_img', locals: { src: src.html_safe })
          .html_safe
      end
  end
end
