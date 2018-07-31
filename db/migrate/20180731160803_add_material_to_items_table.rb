class AddMaterialToItemsTable < ActiveRecord::Migration[5.0]
  def change
    add_column :items,:material,:string
  end
end
