require 'spec_helper'

module Boostify
  describe ApplicationController do
    describe '#get_current_user' do
      subject { ApplicationController.new.get_current_user }
      it { should be_nil }

      context 'with current_user_method returning something' do
        ApplicationController.class_eval do
          define_method :current_user_method do
            User.first_or_create!
          end
        end

        before { Boostify.current_user_method = 'current_user_method' }
        it { should be_a User }
      end
    end
  end
end
