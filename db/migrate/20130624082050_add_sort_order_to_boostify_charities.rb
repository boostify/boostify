class AddSortOrderToBoostifyCharities < ActiveRecord::Migration
  def change
    add_column :boostify_charities, :sort_order, :integer
    add_index :boostify_charities, :sort_order
  end
end
