class AddUserToDonations < ActiveRecord::Migration
  def change
    change_table :boostify_donations do |t|
      t.references :user
    end
    add_index :boostify_donations, :user_id
  end
end
