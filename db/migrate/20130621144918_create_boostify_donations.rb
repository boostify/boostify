class CreateBoostifyDonations < ActiveRecord::Migration
  def change
    create_table :boostify_donations do |t|
      t.integer :donatable_id
      t.integer :charity_id

      t.decimal :amount, precision: 8, scale: 2
      t.decimal :commission, precision: 8, scale: 2
      t.string :status

      t.timestamps
    end
    add_index :boostify_donations, :donatable_id
    add_index :boostify_donations, :charity_id
  end
end
