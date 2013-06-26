class ChangeDonationsToUseMoney < ActiveRecord::Migration
  def change
    change_table :boostify_donations do |t|
      t.remove :amount
      t.remove :commission

      t.money :amount, currency: { default: 'EUR' }
      t.money :commission, currency: { default: 'EUR' }
    end
  end
end
