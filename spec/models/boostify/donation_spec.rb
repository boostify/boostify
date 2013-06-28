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

    describe '#generate_token' do
      before { @donation = Fabricate :donation }

      it 'generates a token' do
        @donation.token.should be
      end
    end

    describe 'private #signature' do
      def signature(hash)
        Donation.new.send(:signature, hash)
      end

      let(:hasha) { { a: 1, b: { c: 3, d: 4 } } }
      let(:hashd) { { b: { d: 4, c: 3 }, a: 1 } }

      it 'calculates the same signature' do
        signature(hasha).should == signature(hashd)
      end
    end
  end
end
