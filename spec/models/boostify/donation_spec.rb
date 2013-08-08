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

    describe '#charity' do
      let(:donation) { Donation.new }
      subject { donation }
      it { should have(:no).errors_on :charity }

      context 'with charity set' do
        let(:charity) { Charity.new }
        before { donation.charity = charity }
        it { should have(:no).errors_on :charity }

        context 'when charity_id is changed' do
          before do
            donation.stub(charity_id_changed?: true)
            donation.stub(charity_id_was: 'not nil')
          end

          it { should have(1).error_on :charity }
        end
      end
    end
  end
end
