class ChangeCharitiesToUseMoney < ActiveRecord::Migration
  def change
    change_table :boostify_charities do |t|
      t.remove :income
      t.money :income, currency: { default: 'EUR' }, cents: { default: 0 }
    end
  end
end
