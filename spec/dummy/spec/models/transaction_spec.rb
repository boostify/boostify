require 'spec_helper'

describe Transaction do

  before do
    @transaction = Transaction.new(
      my_amount: Money.new(150, 'EUR'),
      my_commission: Money.new(100, 'EUR'))
  end

  it 'can configure own amount method' do
    @transaction.donatable_amount.should == Money.new(150, 'EUR')
  end

  it 'can configure own commission method' do
    @transaction.donatable_commission.should == Money.new(100, 'EUR')
  end
end
