require 'spec_helper'

module Boostify
  describe Donation do
    let(:donation) { Fabricate :donation }

    it { donation.should be }
  end
end
