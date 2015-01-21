require 'spec_helper'

describe Boostify::DonationsController do
  routes { Boostify::Engine.routes }

  before do
    @transaction = Transaction.create! my_amount: 1.2, my_commission: 0.70
    @charity_attributes = Fabricate.attributes_for :charity
    @charity = Boostify::Charity.create! @charity_attributes
    @valid_attributes = {
      donatable_id: @transaction.id,
      amount: @transaction.my_amount,
      commission: @transaction.my_commission,
      charity_id: @charity.boost_id.to_s
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
    render_views
    let(:attributes) do
      Fabricate.attributes_for :donation, charity_id: @charity.boost_id
    end
    let(:donation) { Boostify::Donation.create! attributes }
    subject { get :show, id: donation.token }

    it 'assigns @donation' do
      subject
      assigns(:donation).should eq(donation)
    end

    it 'does not show the link to donate via boost' do
      subject
      response.body.should_not include 'Go to'
    end

    context 'without charity_id' do
      before do
        attributes.delete :charity_id
        subject
      end

      it { response.body.should include 'Go to' }
    end
  end

  describe 'PUT update' do
    let(:charity) { @charity }
    let(:donation) { Fabricate :donation, charity: nil, id: 23 }
    let(:timestamp) { Time.now.to_i.to_s }
    let(:attr) do
      {
        id: donation.token,
        timestamp: timestamp,
        donation: {
          charity: @charity_attributes,
          commission: 6.66
        }
      }
    end
    let(:signed_attr) do
      params = HMACAuth::Signature.sign(attr, secret: Boostify.partner_secret)
      params[:format] = :json
      params
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
        it { subject.charity.boost_id.to_s.should == charity.boost_id.to_s }
        it { subject.commission.fractional.should_not == 666 }
      end

      context 'response' do
        subject { response }
        it { should_not be_a_redirect }
        its(:status) { should == 204 }
        its(:body) { should be_blank }
      end
    end

    context 'with a new charity' do
      before do
        attr[:donation][:charity] = Fabricate.attributes_for :charity
      end

      subject { -> { put :update, signed_attr } }

      it { should change(Boostify::Charity, :count).from(1).to(2) }

      context 'after' do
        before { subject.call }

        it { assigns(:donation).charity.should_not == charity }
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

    context 'when changing charity_id' do
      before do
        donation.update_attributes! charity: charity
        attr[:donation][:charity][:boost_id] = charity.boost_id + 1
        put :update, signed_attr
      end
      it_behaves_like 'invalid donation'
    end
  end
end
