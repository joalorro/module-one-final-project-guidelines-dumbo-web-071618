class CreateEnemysTable < ActiveRecord::Migration[5.0]
  def change
    create_table :enemys do |t|
      t.string :species
      t.integer :fp
    end
  end
end
