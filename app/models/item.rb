class Item < ActiveRecord::Base
  has_many :inventorys
  has_many :heros, through: :inventorys
end
