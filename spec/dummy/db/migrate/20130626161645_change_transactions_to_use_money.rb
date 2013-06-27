class ChangeTransactionsToUseMoney < ActiveRecord::Migration
  def change
    remove_column :transactions, :my_amount
    remove_column :transactions, :my_commission
    add_money :transactions, :my_amount
    add_money :transactions, :my_commission
  end
end
