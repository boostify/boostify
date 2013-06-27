require 'spec_helper'

module Boostify
  describe Donation do

    describe 'mass assignment is protected' do
      before do
        @attributes = {
          status: 'hacker status',
          commission: 0.7
        }
      end

      it 'should raise exception, when controller style' do
        parameters = ActionController::Parameters.new(@attributes)
        expect { Donation.create parameters }.to raise_exception
      end

      it 'should not rails exception, when normal style' do
        expect { Donation.create @attributes }.to_not raise_exception
      end
    end
  end
end
