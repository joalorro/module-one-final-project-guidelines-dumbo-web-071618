class CreateHerosTable < ActiveRecord::Migration[5.0]
  def change
    create_table :heros do |t|
      t.string :name
      t.integer :ap
      t.integer :dp
      t.integer :exp
      t.integer :lvl
      t.integer :money
    end
  end
end
