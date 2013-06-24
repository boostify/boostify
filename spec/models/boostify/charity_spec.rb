require 'spec_helper'

module Boostify
  describe Charity do

    describe 'mass assignment is protected' do
      before do
        @attributes = { sort_order: 0 }
      end

      it 'should raise exception, when controller style' do
        parameters = ActionController::Parameters.new(@attributes)
        expect { Charity.create parameters }.to raise_exception
      end

      it 'should not rails exception, when normal style' do
        expect { Charity.create @attributes }.to_not raise_exception
      end
    end
  end
end
