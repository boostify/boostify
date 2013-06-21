class CreateBoostifyCharities < ActiveRecord::Migration
  def change
    create_table :boostify_charities do |t|
      t.integer :boost_id

      t.string :title
      t.string :name
      t.string :url
      t.string :short_description
      t.text :description
      t.string :logo

      t.integer :advocates
      t.decimal :income, precision: 8, scale: 2

      t.timestamps
    end
  end
end
