class CreateItemsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :item_type
      t.integer :point_value
      t.integer :price
    end
  end
end
