require 'spec_helper'

describe Boostify::DonationsController do

  before do
    @transaction = Transaction.create! my_amount: 1.2, my_commission: 0.70
    @charity = Fabricate :charity
    @valid_attributes = {
        amount: @transaction.donatable_amount,
        commission: @transaction.donatable_commission,
        charity_id: @charity.id
    }
    session[:donatable_id] = @transaction.id
  end

  describe 'GET create' do
    it 'returns http success' do
      get :create, donation: @valid_attributes
      response.should be_success
    end
  end

end
