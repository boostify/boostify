class SetCharitiesAdvocatesDefault < ActiveRecord::Migration
  def change
    change_column :boostify_charities, :advocates, :integer, default: 0
  end
end
