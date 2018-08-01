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

  def view_items
    # puts `clear`
    if !self.inventories.empty?
      selection = self.generate_items_array
      selection == "back" ? play_menu(self) : inv_actions(selection)

    else
      TTY::Prompt.new.select("It seems your inventory is empty") do |menu|
        menu.choices Back: "back"
      end
      play_menu self
    end
  end

  def sell

  end

  def generate_items_array
    hash = {}
    self.inventories.each do |inv|
        if hash.key?(inv.item.name.to_sym)
            hash[inv.item.name.to_sym][:count] += 1
        else
            hash[inv.item.name.to_sym] = {inv: inv, count: 1}
        end
    end

    hashe = {}
    hash.each do |k, v|
        hashe["#{v[:count]} #{k.to_s}(s)".to_sym] = [v[:inv].item, v[:count]]
    end

    hashe[:Back] = "back"
    item_arr = TTY::Prompt.new.select("Your inventory") do |menu|
        menu.choices hashe
    end

    item_arr
  end

  def inv_actions inv_arr
    # binding.pry
    i = TTY::Prompt.new.select("Your inventory") do |menu|
        menu.choices Equip: "equip", Unequip: "unequip", Back: "back"
    end
    case i
      when "equip"

      when "unequip"

      when "back"
          play_menu self
    end
  end

  def shop
    puts "You have: #{self.money} gold dragons."

    prompt = TTY::Prompt.new
    i = prompt.select("Can I help you?") do |menu|
        menu.choices  Buy: "buy",
                      Sell: "sell",
                      "View Stock" => "view",
                      Back: "back"
    end

    case i
      when "buy"
        item_type
      when "sell"
        view_inventory_for_selling
      when "view"
        show_shop_items
      when "back"
        puts `clear`
        play_menu self
    end
    shop
  end






  def equipped_items #######NOT TESTED#############
    self.items.select do |item|
      item.inventory.equip == true
    end
  end

  def buy_item

  end

  def equip_item

  end
  ## CLASS METHODS ##

  ## PRIVATE METHODS ##
  private

  def show_shop_items
    puts `clear`
    Item.all.each do |item|
      puts "#{item.material.capitalize} #{item.item_type.capitalize}      -       #{item.price} Gold Dragons"
    end
  end

  def item_type
      puts `clear`
      prompt = TTY::Prompt.new
      choice = prompt.select("What would you like to purchase?") do |menu|
          menu.choices Swords: "sword", Shields: "shield", Armor: "armor", Boots: "boots", Gauntlets: "gauntlets", Helmets: "helmet", Back: "back"
      end
      shop if choice == "back"
      material_menu choice
  end

  def material_menu choice

      prompt = TTY::Prompt.new
      material = prompt.select("Material Type:") do |menu|
          menu.choices Wood: "wood", Steel: "steel", Adamantium: "adamantium", Back: "back"
      end
      item_type if material == "back"
      selected_item = Item.find_by(material: material, item_type: choice)
      buy selected_item
  end

  def buy item
    if item.price > self.money
      puts `clear`
      puts "Sorry, you can't afford this."
      puts "You need #{item.price - self.money} more gold dragons in order to purchase this #{item.name}."
    else
      i = Inventory.create
      i.hero = self
      i.item = item
      i.equip = false
      self.money -= item.price
      i.save
      self.save
      puts `clear`
      puts "Thank you for your custom."
      puts "#{item.name} was added to your inventory."
    end
  end

  def sell_item item_array
    item = item_array[0]
    count = item_array[1]


    inv_instance = Inventory.find_by(hero_id: self.id, item_id: item.id)

    self.inventories.delete inv_instance
    self.money += item.price
    self.save
  end

  def view_inventory_for_selling
    if !self.inventories.empty?
    sell_item self.generate_items_array
    else
      TTY::Prompt.new.select("It seems your inventory is empty") do |menu|
        menu.choices Back: "back"
      end
    end
    puts `clear`
    shop if item_to_be_sold = "back"
    sell_item item_to_be_sold
  end

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
