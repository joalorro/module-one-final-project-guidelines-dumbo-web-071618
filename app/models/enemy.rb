class Enemy < ActiveRecord::Base
  has_many :fights
  has_many :heros, through: :fights
end
