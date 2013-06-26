class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.float :my_amount
      t.float :my_commission
    end
  end
end
