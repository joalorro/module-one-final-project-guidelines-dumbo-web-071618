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

    limit = (100 * (1.2 ** (self.lvl - 1))).to_i
    rem = self.exp - limit
    if self.exp >= limit
      self.lvl += 1
      puts "Congratualations! You level up to #{self.lvl}!"
      self.exp = rem
      inc_power if self.lvl % 2 == 0
    end
    self.save
  end

  def inc_power
    self.ap += 1
    self.dp += 1
  end

  def update_inventory
    self.inventories = Hero.find(self.id).inventories
  end
##########FIGHT BEGINS#################
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
      # apply_money_xp
    else
      #lose
      puts "You lose"
      fight.win = false
    end
    fight.save
    apply_money_xp
    level_up
  end


  def apply_money_xp
    last_fight = Fight.last
    money_to_be_added = rand(0..7)
    xp_to_be_added = rand(3..7)
    # xp_to_be_added = 50
    self.money += money_to_be_added
    self.exp += xp_to_be_added
    self.save
    puts "You gained #{money_to_be_added} gold dragon(s) and #{xp_to_be_added} xp points."
  end

  #################FIGHT ENDS###################

  ################# STATS ###########################

  def display_stats
    puts `clear`
    limit = (100 * (1.2 ** (self.lvl - 1))).to_i

    puts "Name: #{self.name}"
    puts "Level: #{self.lvl}"
    puts "Attack Power: #{self.ap}"
    puts "Defensive Power: #{self.dp}"
    puts "Experience: #{self.exp} / #{limit}"
    puts "Gold dragon(s): #{self.money}"
    puts "Equipment:"
    display_equipment
    choice = generate_menu options: {Back: "back", "Unequip All" => "UE all"}

    if choice == "back"
      puts `clear`
      play_menu self
    elsif choice == "UE all"
      puts `clear`
      unequip_all
      display_stats
    end
  end

  def adjust_ap_or_dp adjustment,item
    if adjustment == "inc"
      if item.item_type == "sword"
        self.ap += item.point_value
      else
        self.dp += item.point_value
      end
    else
      if item.item_type == "sword"
        self.ap -= item.point_value
      else
        self.dp -= item.point_value
      end
    end
    self.save
  end

  ################ END STATS ########################

  ################ INVENTORY ########################
  def view_items
    puts "You have #{self.money} gold dragons."
    if !self.inventories.empty?
      selection = self.generate_items_array
      if selection == "back"
        puts `clear`
        play_menu(self)
      else
        inv_actions(selection)
      end
    else
      choice = generate_menu message: "It seems your inventory is empty", options: {Back: "back"}
      play_menu self
    end
    puts `clear`
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

    item_arr = generate_menu message: "Your inventory", options: hashe
    item_arr
  end

  def inv_actions inv_arr
    item = inv_arr[0]
    count = inv_arr[1]

    choice = generate_menu message: "Your inventory", options: {Equip: "equip", Unequip: "unequip", Back: "back"}

    case choice
      when "equip"
        equip_item item
        view_items
      when "unequip"
        unequip item
        view_items
      when "back"
        play_menu self
    end
  end

  ################## END INVENTORY #######################

  ############## EQUIPMENT FUNCTIONS #####################

  def equip_item item
    inv_instance = self.inventories.find_by item_id: item.id #=> inventory instance that matches the item
    #Unequip the item of the same item_type

    item_to_be_unequipped = self.inventories.find do |inv|
      inv_instance.id != inv.id && inv_instance.item.item_type == inv.item.item_type
    end
    unequip item_to_be_unequipped if item_to_be_unequipped
    if !inv_instance.equip && inv_instance
      adjust_ap_or_dp("inc", inv_instance.item)
      inv_instance.equip = true
      inv_instance.save
    end
    puts `clear`
    puts "You equip your #{inv_instance.item.name}"
    update_inventory
  end

  def display_equipment
    equipment_hash = {
      sword: nil,
      shield: nil,
      helmet: nil,
      armor: nil,
      gauntlets: nil,
      boots: nil
    }
    self.inventories.select do |inv|
      inv.equip == true
    end.each do |inv|
      equipment_hash[inv.item.item_type.to_sym] = inv.item.name
    end
    equipment_hash.each do |item_type,item|
      if !item.nil?
        puts " - #{item_type.to_s.capitalize}: #{item.split[0]}"
      else
        puts " - #{item_type.to_s.capitalize}:"
      end
    end
  end

  def unequip item
    puts `clear`
    inv = self.inventories.find do |inv|
      inv.item_id == item.id
    end
    puts `clear`
    if inv.equip && !inv.nil?
      inv.equip = false
      adjust_ap_or_dp "dec",item
      puts "You unequip your #{item.name}."
    else
      puts "bruh, you weren't wearing that"
    end
    inv.save
    update_inventory
  end

  def unequip_all
    self.inventories.each do |inv|
      if inv.equip
        inv.equip = false
        adjust_ap_or_dp "dec",inv.item
      end
      inv.save
    end
    self.save
    update_inventory
    puts "You unequip everything."
  end

  ########### END EQUIPMENT FUNCTIONS ####################

  def shop
    puts "You have: #{self.money} gold dragons."

    choice = generate_menu message: "How can I help you?", options: {Buy: "buy",Sell: "sell","View Stock" => "view", Back: "back"}

    case choice
      when "buy"
        item_type
      when "sell"
        puts `clear`
        view_inventory_for_selling
      when "view"
        puts `clear`
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

  ## CLASS METHODS ##

  ## PRIVATE METHODS ##
  private

  def show_shop_items
    puts `clear`
    Item.all.each do |item|
      puts "#{item.material.capitalize} #{item.item_type.capitalize}\t \t-\t#{item.price} Gold Dragons"
    end
  end

  def item_type
    puts `clear`

    choice = generate_menu message: "What would you like to purchase?", options: {Swords: "sword", Shields: "shield", Armor: "armor", Boots: "boots", Gauntlets: "gauntlets", Helmets: "helmet", Back: "back"}

    shop if choice == "back"
    material_menu choice
  end

  def material_menu choice
    material = generate_menu message: "Material Type:", options: {Wood: "wood", Steel: "steel", Adamantium: "adamantium", Back: "back"}

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
      inv_instance = Inventory.create
      inv_instance.hero = self
      inv_instance.item = item
      inv_instance.equip = false
      self.money -= item.price
      inv_instance.save
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
    sell_value = (0.25 * item.price).to_i

    self.inventories.delete inv_instance
    self.money += sell_value
    self.save

    puts `clear`

    puts "You have sold 1 #{item.name} for #{sell_value} gold dragons."
  end

  def view_inventory_for_selling
    puts "You have #{self.money} gold dragons."
    if !self.inventories.empty?
      selection =  self.generate_items_array
      selection == "back" ? (shop) : sell_item(selection)
    else
      choice = generate_menu message: "It seems your inventory is empty",options: {Back: "back"}
      shop
    end

    # item_to_be_sold == "back" ? shop : sell_item(item_to_be_sold)
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
