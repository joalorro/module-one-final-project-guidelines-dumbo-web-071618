class AddTiersToEnemies < ActiveRecord::Migration[5.0]
  def change
    add_column :enemies, :tier, :integer
  end
end
