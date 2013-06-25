class Boostify::DonationsController < ApplicationController

  # in params complete donation needed (with charity, amount, etc.)
  # in session donatable_id needed
  def create
    #TODO validate some presents...
    if @donation = Boostify::Donation.create(donation_params)
      #TODO handler for app
      # check if current_user is transaction.transactioning
      Transaction.create!(
        my_amount: - @donation.donatable.donatable_commission,
        my_commission: 0)

      #TODO send donation to boost
      session[:donarable_id] = nil
      redirect_to donation_path(@donation)
    else
      render controller: :charities, action: :index
    end
  end

  def show
    @donation = Boostify::Donation.find params[:id]
    #TODO redirect to boost
  end

  private

    def donation_params
      params.require(:donation).permit(:amount, :commission, :charity_id)
        .merge(donatable_id: session[:donatable_id])
    end
end
