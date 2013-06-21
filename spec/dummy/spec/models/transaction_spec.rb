require 'spec_helper'

describe Transaction do

  before { @transaction = Transaction.new my_amount: 1.50, my_commission: 1.00 }

  it 'can configure own amount method' do
    @transaction.donatable_amount.should eq(1.50)
  end

  it 'can configure own commission method' do
    @transaction.donatable_commission.should eq(1.00)
  end
end
