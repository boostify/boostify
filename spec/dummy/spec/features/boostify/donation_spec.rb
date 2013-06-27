require 'spec_helper'

describe Boostify::Donation, :feature do

  before do
    Fabricate :charity
    Transaction.create! my_amount: 100.0, my_commission: 99.0
    visit transactions_path
  end

  context 'when clicking on donate' do
    before  { click_on 'donate 99' }

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
end
