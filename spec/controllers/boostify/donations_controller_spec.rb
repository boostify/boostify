require 'spec_helper'

describe Boostify::DonationsController do

  before do
    @transaction = Transaction.create! my_amount: 1.2, my_commission: 0.70
    @charity = Fabricate :charity
    @valid_attributes = {
        donatable_id: @transaction.id,
        amount: @transaction.my_amount,
        commission: @transaction.my_commission,
        charity_id: @charity.id.to_s
    }
    session[:donatable_id] = @transaction.id
  end

  describe 'POST create' do
    before do
      post :create, donation: @valid_attributes
    end

    it 'returns http redirect' do
      response.should be_redirect
    end

    it 'assigns @donation' do
      assigns(:donation).should be
    end
  end

end
