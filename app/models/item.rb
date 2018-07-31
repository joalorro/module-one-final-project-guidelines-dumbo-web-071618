class Item < ActiveRecord::Base
  has_many :inventories
  has_many :heros, through: :inventories

  def name 
    "#{self.material.capitalize} #{self.item_type.capitalize}"
  end 
end
