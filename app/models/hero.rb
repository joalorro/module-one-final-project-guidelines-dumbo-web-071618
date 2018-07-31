class Hero < ActiveRecord::Base
  belongs_to :user
  has_many :items, through: :inventorys
  has_many :inventorys

  has_many :fights
  has_many :enemys, through: :fights
  # attr_accessor :name, :ap, :dp, :exp, :lvl, :inventory, :money

  ## INSTANCE METHODS ##

  def level_up
    #if @exp meets the *level up* threshold, then increment Level by 1 & restart hero's
    #exp value to 0. If @exp is greater than the threshold, take the difference between
    # current @exp and the threshold and add it to the @exp value after leveling up & restarting
    # the @exp to 0

    limit = 1000 * (1.2 ** (@lvl - 1))
    rem = @exp - limit
    if @exp >= limit
      @lvl += 1
      @exp = rem
    end
  end

  def fight
    hero_fp = ((2.0/3.0)*@ap.to_f + (1.0/3.0)*@dp.to_f).to_i
    enemy_fp = (rand(50..120)/100) * self.fp

    enemy = Enemy.new name:
    fight = Fight.create hero_id: self.id, enemy_id: enemy.id, fp: enemy_fp

    winning_chance = (hero_fp/(hero_fp + fight.fp)) * 100
    losing_chance = 100 - winning_chance
    random_number = rand(1..100)

    if winning_chance >= random_number
      #then win
    else
      #lose
    end

  end

  ## CLASS METHODS ##
end
