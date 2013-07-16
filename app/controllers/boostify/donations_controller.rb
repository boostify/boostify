module Boostify
  class DonationsController < Boostify::ApplicationController
    include SignatureVerificationHelper

    respond_to :html, except: :update
    respond_to :json, only: :update

    before_filter :verify_signature!, only: :update

    def new
      session[:donatable_id] = params[:id]
      redirect_to charities_path
    end

    # in params complete donation needed (with charity, amount, etc.)
    # in session donatable_id needed
    def create
      @donation = Donation.new(donation_params)
      before_donation_creation @donation
      if @donation.save
        after_donation_creation @donation
        session[:donatable_id] = nil
        flash[:notice] = pixel_img + t('flash.donation.success')
        redirect_to donation_path(@donation)
      else
        redirect_to charities_path
      end
    end

    def update
      donation.update_attributes update_donation_params
      respond_with donation
    end

    def show
      respond_with donation
    end

    private

      def donation_params
        params.require(:donation).permit(:amount, :commission, :charity_id)
          .merge(donatable_id: session[:donatable_id], user: get_current_user)
      end

      def update_donation_params
        params.require(:donation).permit(:charity_id)
      end

      def after_donation_creation(donation)
        #TODO create a transaction to the donation
        # do not forget to do some validations
        # (p.e. user is allowed to create a transaction)
        if defined?(super)
          super donation
        end
      end

      def before_donation_creation(donation)
        if defined?(super)
          super donation
        end
      end

      def pixel_img
        src = @donation.pixel_url
        render_to_string(partial: 'pixel_img', locals: { src: src.html_safe })
          .html_safe
      end

      def donation
        @donation ||= Donation.find params[:id]
      end
  end
end
