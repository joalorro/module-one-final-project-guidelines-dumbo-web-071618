class Item < ActiveRecord::Base
  has_many :inventories
  has_many :heros, through: :inventories
end
