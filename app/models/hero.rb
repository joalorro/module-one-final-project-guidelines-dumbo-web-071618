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
    pastel = Pastel.new
    message = "Congratualations! You level up to #{self.lvl}!"
    pastel.decorate(message, :green)
    limit = (100 * (1.2 ** (self.lvl - 1))).to_i
    rem = self.exp - limit
    if self.exp >= limit
      self.lvl += 1
      self.exp = rem
      puts pastel.decorate(message, :green)
    end
    self.save
  end

##########FIGHT BEGINS#################
  def fight
    pastel = Pastel.new
    hero_fp = ((2.0/3.0)*self.ap.to_f + (1.0/3.0)*self.dp.to_f).round(2)
    enemy_fp = ((rand(30..150)/100.0) * hero_fp).round(2)
    last_enemy_id = (Enemy.all[-1]).id
    enemy = Enemy.find(rand(1..last_enemy_id))
    fight = Fight.create(hero_id: self.id, enemy_id: enemy.id, fp: enemy_fp)
    winning_chance = (hero_fp/(hero_fp + fight.fp)) * 100
    losing_chance = 100 - winning_chance
    random_number = rand(1..100)

    puts `clear`

    puts "You encounter a #{enemy.species} with the power of #{enemy_fp}"
    puts "Your chances of winning are #{winning_chance.round(1)}%"
    puts "Godspeed."
    # add time between the encounter and the result
    #####DELAY BEGINS#########
    i = 3
    str = "Fighting"
    loop do
      print i.to_s + "\r"
      $stdout.flush
      i = i.to_i
      i -= 1
      sleep 1
      break if i == 0
    end
    ########DELAY ENDS########

    if winning_chance >= random_number
      #then win
      puts pastel.decorate("You win", :green)
      fight.win = true
      # apply_money_xp
    else
      #lose
      puts pastel.decorate("You lose", :red)
      fight.win = false
    end
    fight.save
    apply_money_xp
    level_up
  end


  def apply_money_xp
    pastel = Pastel.new
    last_fight = Fight.last
    money_to_be_added = rand(0..7)
    xp_to_be_added = rand(3..7)
    # xp_to_be_added = 50
    self.money += money_to_be_added
    self.exp += xp_to_be_added
    self.save
    puts "You gained"
    print pastel.decorate("#{money_to_be_added} gold dragon(s)", :yellow)
    print " and " 
    print pastel.decorate("#{xp_to_be_added} xp points.", :blue)
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
    back_button = TTY::Prompt.new.select("") do |menu|
      menu.choices Back: "back"
    end
    if back_button == "back"
      puts `clear`
      play_menu self
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
    # binding.pry
  end

  ################ END STATS ########################
  ###############################FIGHT HISTORY BEGINS###########################
  def display_fight_history
    puts `clear`
    self.fights.each do |fight|
      fight.win ? result = "won" : result = "lost"
      puts "You've fought a " + fight.enemy.species.capitalize + " with the power of " + fight.fp.to_s + " and " + result + "."
    end
  end




  ####################FIGHT HISTORY ENDS#################################

  ################ INVENTORY ########################
  def view_items
    puts "You have #{self.money} gold dragons."
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

    item = inv_arr[0]
    count = inv_arr[1]

    i = TTY::Prompt.new.select("Your inventory") do |menu|
        menu.choices Equip: "equip", Unequip: "unequip", Back: "back"
    end
    case i
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
    if !inv_instance.equip
      adjust_ap_or_dp("inc", inv_instance.item)
      inv_instance.equip = true
      inv_instance.save
    end
    puts "You equip your #{inv_instance.item.name}"
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
    if inv.equip
      inv.equip = false
      adjust_ap_or_dp "dec",item
      puts "You unequip your #{item.name}."
    else
      puts "bruh, you weren't wearing that"
    end
    inv.save
  end

  ########### END EQUIPMENT FUNCTIONS ####################

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

  def equip(inv_arr)

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
      i = TTY::Prompt.new.select("It seems your inventory is empty") do |menu|
        menu.choices Back: "back"
      end
      shop if i == "back"
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
