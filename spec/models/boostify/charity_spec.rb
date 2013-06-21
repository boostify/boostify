require 'spec_helper'

module Boostify
  describe Charity do
    let(:charity) { Fabricate :charity }

    it { charity.should be }
  end
end
