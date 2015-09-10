module Boostify
  class DonationsController < Boostify::ApplicationController
    include SignatureVerificationHelper

    respond_to :html, except: :update
    respond_to :json, only: :update

    skip_before_filter :verify_authenticity_token, only: :update
    before_filter :verify_signature!, only: :update

    def new
      redirect_to charities_path(donatable_id: params[:id])
    end

    # in params complete donation needed (with charity, amount, etc.)
    def create
      @donation = Donation.new(donation_params)
      before_donation_creation @donation
      if @donation.save
        after_donation_creation @donation
        set_after_create_flash_message
        redirect_to donation_path(@donation)
      else
        redirect_to charities_path
      end
    end

    def update
      donation.charity = charity
      donation.save
      respond_with donation
    end

    def show
      respond_with donation
    end

    private

      def donation_params
        params.require(:donation)
          .permit(:amount, :commission, :charity_id, :donatable_id)
          .merge(user: get_current_user)
      end

      def update_donation_params
        params.require(:donation).
          permit(charity: charity_attributes)
      end

      def charity_attributes
        [:boost_id, :title, :name, :url, :short_description,
         :description, :logo, :cover]
      end

      def charity
        @charity ||=
          Charity.find_by_boost_id_or_create(update_donation_params[:charity])
      end

      def after_donation_creation(donation)
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

      def set_after_create_flash_message
        key = @donation.charity.nil? ? :other_charity : :success
        flash[:notice] = pixel_img << t(key, scope: [:flash, :donation])
      end

      def donation
        @donation ||= Donation.where(token: params[:id]).first
      end
  end
end
