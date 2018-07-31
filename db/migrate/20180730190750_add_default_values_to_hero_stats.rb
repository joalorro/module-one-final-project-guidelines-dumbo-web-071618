class AddDefaultValuesToHeroStats < ActiveRecord::Migration[5.0]
  def up
    change_column :heros,:ap, :integer, :null => false, :default => 10
    change_column :heros,:dp, :integer, :null => false, :default => 10
    change_column :heros,:exp, :integer, :null => false, :default => 0
    change_column :heros,:lvl, :integer, :null => false, :default => 1
    change_column :heros,:money, :integer, :null => false, :default => 100
  end

  def down
    change_column :heros, :ap, :integer
    change_column :heros,:dp, :integer
    change_column :heros,:exp, :integer
    change_column :heros,:lvl, :integer
    change_column :heros,:money, :integer
  end
end
