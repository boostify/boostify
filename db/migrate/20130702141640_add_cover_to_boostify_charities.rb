class AddCoverToBoostifyCharities < ActiveRecord::Migration
  def change
    add_column :boostify_charities, :cover, :string
  end
end
