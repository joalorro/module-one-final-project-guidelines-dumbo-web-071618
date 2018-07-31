class AddWinColumnToFightsTable < ActiveRecord::Migration[5.0]
  def change
    add_column :fights, :win, :boolean
  end
end
