class CreateFightsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :fights do |t|
      t.integer :hero_id
      t.integer :enemy_id
      t.integer :fp
    end
  end
end
