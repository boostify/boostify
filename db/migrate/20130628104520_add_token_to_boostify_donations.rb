class AddTokenToBoostifyDonations < ActiveRecord::Migration
  def change
    add_column :boostify_donations, :token, :string
    add_index :boostify_donations, :token, unique: true
  end
end
