class User < ActiveRecord::Base
  has_one :hero
end
