class Inventory < ActiveRecord::Base
  belongs_to :hero
  belongs_to :item

end
