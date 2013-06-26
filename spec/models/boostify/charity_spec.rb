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

    describe 'after_touch callbacks' do
      before do
        @charity = Fabricate :charity
      end

      subject { @charity }

      its(:income) { should == Money.new(0, Boostify::CURRENCY) }
      its(:advocates) { should == 0 }

      context 'when a donation is created' do
        before do
          @donation = Fabricate :donation, charity: @charity
        end

        its(:income) { should == @donation.commission }
        its(:advocates) { should == 0 }

        context 'when the donation has a user' do
          before do
            @donation.user = User.create!
            @donation.save!
          end

          it { @donation.user should be }
          its(:advocates) { should == 1 }
        end
      end
    end
  end
end
