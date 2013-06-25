require 'spec_helper'

module Boostify

  describe CharitiesController do

    describe 'GET index' do
      before do
        @charities = (0..5).map { Fabricate :charity }
        @transaction = Transaction.create! my_amount: 1.2, my_commission: 0.7
        session[:donatable_id] = @transaction.id
      end

      it 'assigns charities as @charities' do
        get :index
        assigns(:charities).to_a.should eq(@charities)
      end
    end

    describe 'GET show' do
      before do
        @charity = Fabricate :charity
      end

      it 'assigns the requested charity as @charity' do
        get :show, { id: @charity.to_param }
        assigns(:charity).should eq(@charity)
      end
    end
  end
end
