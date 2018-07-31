class Fight < ActiveRecord::Base
  belongs_to :enemy
  belongs_to :hero
end
