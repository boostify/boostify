require 'spec_helper'

module Boostify

  describe CharitiesController do

    before do
      @transaction = Fabricate :transaction
    end

    describe 'GET index' do
      before do
        @charities = (0..5).map { Fabricate :charity }
        Boostify.favorite_charity_ids = @charities.map(&:boost_id)
      end

      context 'with available donatable_id' do
        before do
          session[:donatable_id] = @transaction.id
          get :index
        end

        it 'assigns charities as @charities' do
          assigns(:charities).sort_by(&:id).should eq(@charities.sort_by(&:id))
        end

        it 'assigns new donation as @donation' do
          assigns(:donation).should be
          assigns(:donation).amount.should eq(@transaction.donatable_amount)
        end
      end

      context 'with no donatable_id' do

        it 'does not assign donation' do
          get :index
          assigns(:donation).should be_nil
        end
      end
    end

    describe 'GET show' do
      before do
        @charity = Fabricate :charity
      end

      context 'with available donatable_id' do
        before { session[:donatable_id] = @transaction.id }

        it 'assigns the requested charity as @charity' do
          get :show, { id: @charity.to_param }
          assigns(:charity).should eq(@charity)
        end
      end

      context 'with no donatable_id' do

        it 'does not assign donation' do
          get :show, { id: @charity.to_param }
          assigns(:charity).should eq(@charity)
        end
      end
    end
  end
end
