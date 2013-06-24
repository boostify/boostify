class Boostify::DonationController < ApplicationController

  def new
    @donation = Donation.new
  end

  def create
    Donation.create! params[:donation]
    #TODO send donation to boost
  end

  def show
    @donation = Donation.find params[:id]
  end
end
