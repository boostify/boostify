class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_donation_creation(donation)
    Transaction.create!(
      my_amount: - donation.donatable.donatable_commission,
      my_commission: 0)
  end
end
