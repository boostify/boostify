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

      context 'flash message' do
        render_views
        before do
          Timecop.freeze
          post :create, donation: @valid_attributes
        end
        after { Timecop.return }
        subject { flash[:notice] }
        it { should include assigns(:donation).pixel_url }
        it { should include 'successfully donated' }
      end

      context 'without selecting a charity' do
        render_views
        before do
          @valid_attributes.delete :charity_id
          Timecop.freeze
          post :create, donation: @valid_attributes
        end
        after { Timecop.return }

        subject { flash[:notice] }
        it { should include assigns(:donation).pixel_url }
        it { should include 'redirected' }
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
    let(:attributes) { @valid_attributes }
    let(:donation) { Boostify::Donation.create! attributes }
    subject { get :show, id: donation.token }

    it 'assigns @donation' do
      subject
      assigns(:donation).should eq(donation)
    end

    context 'without charity_id' do
      render_views
      before do
        attributes.delete :charity_id
        subject
      end

      it { response.body.should include 'Go to' }
    end
  end

  describe 'PUT update' do
    let(:donation) { Fabricate.build :donation, charity: nil, id: 23 }
    let(:timestamp) { Time.now.to_i.to_s }
    let(:attr) do
      {
        id: donation.token,
        timestamp: timestamp,
        donation: { charity_id: 42, commission: 6.66 }
      }
    end
    let(:signed_attr) do
      params = Boostify::Signature.sign(attr)
      params[:format] = :json
      params
    end

    before do
      donation.send(:generate_token)
      Boostify::Donation.stub(:where).with(token: donation.token).
        and_return([donation])
    end

    context 'with format != json' do
      before { put :update, signed_attr.merge(format: :html) }
      it { response.status.should == 406 }
      it { response.body.should be_blank }
    end

    context 'valid attributes' do
      before { put :update, signed_attr }

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

    context 'invalid timestamp' do
      let(:timestamp) { 16.minutes.ago.to_i }
      before { put :update, signed_attr }
      it { assigns(:donation).should be_nil }
      it { response.status.should == 422 }
    end

    shared_examples_for 'invalid donation' do
      subject { response }
      it { should_not be_a_redirect }
      its(:status) { should == 422 }
      it { assigns(:donation).should_not be_valid }
    end

    context 'invalid donation' do
      before do
        donation.commission = nil
        put :update, signed_attr
      end
      it_behaves_like 'invalid donation'
    end

    context 'when changing charity_id' do
      before do
        donation.update_attributes! charity_id: 42
        attr[:donation][:charity_id] = 23
        put :update, signed_attr
      end
      it_behaves_like 'invalid donation'
    end
  end
end
