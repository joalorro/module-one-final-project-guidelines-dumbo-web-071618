class AddUserIdToHeros < ActiveRecord::Migration[5.0]
  def change
    add_column :heros, :user_id, :integer 
  end
end
