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

    describe '.favorites' do
      let(:charities) { Charity.favorites }

      before do
        @charities = 3.times.map { |i| Fabricate :charity, boost_id: i + 1 }
        @first, @second, @third = @charities
        Boostify.favorite_charity_ids = [@second, @third].map(&:boost_id)
      end

      subject { charities }

      it { should have(2).items }
      it { should include @second }
      it { should include @third }

      context 'with sort_order specified' do
        before do
          @second.sort_order = 1
          @second.save!
          @third.sort_order = 2
          @third.save!
        end

        it { should have(2).items }
        its(:first) { should == @third }
        its(:last) { should == @second }
      end
    end
  end
end
