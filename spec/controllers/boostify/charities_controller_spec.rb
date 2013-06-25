require 'spec_helper'

module Boostify

  describe CharitiesController do
    before { @routes = Boostify::Engine.routes }

    describe 'GET index' do
      before do
        @charities = (0..5).map { |id| Fabricate :charity, boost_id: id }
      end

      it 'assigns charities as @charities' do
        get :index
        assigns(:charities).sort_by(&:id).should eq(@charities.sort_by(&:id))
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
