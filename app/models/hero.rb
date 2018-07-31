class Hero < ActiveRecord::Base
  belongs_to :user
  has_many :items, through: :inventories
  has_many :inventories

  has_many :fights
  has_many :enemies, through: :fights
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
    hero_fp = ((2.0/3.0)*self.ap.to_f + (1.0/3.0)*self.dp.to_f).round(2)
    enemy_fp = ((rand(30..150)/100.0) * hero_fp).round(2)
    last_enemy_id = (Enemy.all[-1]).id
    enemy = Enemy.find(rand(1..last_enemy_id))
    fight = Fight.create(hero_id: self.id, enemy_id: enemy.id, fp: enemy_fp)
    winning_chance = (hero_fp/(hero_fp + fight.fp)) * 100
    losing_chance = 100 - winning_chance
    random_number = rand(1..100)

    puts `clear`

    puts "You encounter a #{enemy.species} with the power of #{enemy_fp}."
    puts "Your chances of winning are #{winning_chance.round(1)}%."
    puts "Godspeed."
    # add time between the encounter and the result

    if winning_chance >= random_number
      #then win
      puts "You win"
      fight.win = true
    else
      #lose
      puts "You lose"
      fight.win = false
    end
    fight.save
  end

  def equipped_items #######NOT TESTED#############
    hero.items.select do |item|
      item.inventory.equip == true
    end
  end

  def buy_item

  end

  def equip_item

  end

  ## CLASS METHODS ##

  ## PRIVATE METHODS ##

 def time
    i = 0
    start_time = Time.now
    seconds = 3
    end_time = start_time + seconds 
    str = "fighting"
    while Time.now < end_time
      if Time.now % 250 == 0
        print str
        
        str.count(".") < 5 ? str += "." : str = "fighting"
      end
    end

  end

end
