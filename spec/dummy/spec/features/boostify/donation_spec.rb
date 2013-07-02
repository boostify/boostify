require 'spec_helper'

describe Boostify::Donation, :feature do

  before do
    @charity = Fabricate :charity
    Boostify.favorite_charity_ids = [@charity.boost_id]
    Transaction.create! my_amount: 100.0, my_commission: 99.0
  end

  context 'when clicking on donate' do
    before  do
      visit transactions_path
      click_on 'donate 99'
    end

    it 'loads Boostify::Charities#index' do
      current_path.should == boostify.charities_path
    end

    context "when clicking on charity's donate" do
      before do
        Timecop.freeze
        click_button 'donate 99'
      end

      after do
        Timecop.return
      end

      it 'loads Boostify::Donations#show' do
        current_path.should == boostify.donation_path(Boostify::Donation.last)
      end

      it 'show tracking pixel' do
        src = Boostify::Donation.last.pixel_url
        page.should have_xpath("//img[@src=\"#{src}\"]")
      end

      it 'created a new Transaction' do
        Transaction.count.should eq(2)
      end
    end
  end

  context 'when visiting charities without donatable' do

    it 'can visit index' do
      visit boostify.charities_path
    end

    it 'can visit single charity' do
      visit boostify.charity_path(@charity)
    end
  end
end
