class AddAnEquipColumnToInventory < ActiveRecord::Migration[5.0]
  def change
    add_column :inventories,:equip,:boolean
  end
end
