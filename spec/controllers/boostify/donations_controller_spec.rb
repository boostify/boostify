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
  end

  describe 'POST create' do
    before { session[:donatable_id] = @transaction.id }

    context 'with valid attributes' do

      it 'calls after_donation_creation' do
        Boostify::DonationsController.any_instance
          .should_receive(:after_donation_creation)
        post :create, donation: @valid_attributes
      end

      context 'after request' do

        before do
          post :create, donation: @valid_attributes
          @donation = Boostify::Donation.last
        end

        it 'redirects to the created donation' do
          response.should redirect_to(@donation)
        end

        it 'assigns created donation as @donation' do
          assigns(:donation).should be_a Boostify::Donation
          assigns(:donation).should be_persisted
        end
      end

      context 'with rendered views' do
        render_views

        it 'creates flash message with pixel_url' do
          Timecop.freeze do
            post :create, donation: @valid_attributes
            flash[:notice].should include(assigns(:donation).pixel_url)
          end
        end
      end
    end

    context 'with invalid attributes' do

      before do
        @invalid_attributes = @valid_attributes.merge({ commission: nil })
      end

      it 'does not create a new donation' do
        expect { post :create, donation: @invalid_attributes }
          .to_not change(Boostify::Donation, :count)
      end

      it 'redirects to charities path' do
        post :create, donation: @invalid_attributes
        response.should redirect_to charities_path
      end
    end
  end

  describe 'GET show' do

    before do
      @donation = Boostify::Donation.create! @valid_attributes
      get :show, id: @donation.id.to_s
    end

    it 'assigns @donation' do
      assigns(:donation).should eq(@donation)
    end
  end

  describe 'PUT update' do
    let(:donation) { Fabricate.build :donation, charity: nil, id: 23 }
    let(:attr) do
      { id: donation.id,
        donation: { charity_id: '42', commission: '6.66' },
        format: :json }
    end

    before do
      Boostify::Donation.stub(:find).with(donation.id.to_s).and_return(donation)
    end

    context 'with format != json' do
      before { put :update, attr.merge(format: :html) }
      it { response.status.should == 406 }
      it { response.body.should be_blank }
    end

    context 'valid attributes' do

      before { put :update, attr }

      context 'donation' do
        subject { assigns(:donation) }
        it { should == donation }
        it { should be_persisted }
        it { subject.charity_id.to_s.should == '42' }
        it { subject.commission.fractional.should_not == 666 }
      end

      context 'response' do
        subject { response }
        it { should_not be_a_redirect }
        its(:status) { should == 204 }
        its(:body) { should be_blank }
      end
    end

    context 'when saving fails' do
      before do
        donation.donatable = nil
        put :update, attr
      end
      it { assigns(:donation).should_not be_persisted }
      subject { response }
      it { should_not be_a_redirect }
      its(:status) { should == 422 }
    end
  end
end
