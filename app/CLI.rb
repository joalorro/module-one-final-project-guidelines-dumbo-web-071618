def main
    i = TTY::Prompt.new.select("Welcome to the game of .. ") do |menu|
        menu.choices Login: "login", "Sign Up" => "signup", Exit: "exit"
    end

    case i
        when "login"
            hero = login
        when "signup"
            hero = signup.hero
        when "exit"
            puts "Thanks fo playin sucka"
            exit
    end
    puts `clear`
    play_menu hero
end

def login
    puts "Please enter your username"
    name = gets.chomp
    name = name.downcase
    if !User.find_by(name: name)
      ## Direct hero to create a new hero
      puts "We don’t have your name on profile, so we will create one for you!"
      # Call on signup
      user = signup name
    else
      user = User.find_by name: name
    end
    # binding.pry
    hero = user.hero
    hero
end

def signup name = nil
    if name == nil
      puts "Enter your new username"
      name = gets.chomp
       if User.find_by(name: name.downcase)
        puts `clear`
        puts "That username is already taken, try again."
        main
      end
    end
<<<<<<< HEAD

    def self.inv_actions(hero, inv_arr)
        # binding.pry
        i = TTY::Prompt.new.select("Your inventory") do |menu|
            menu.choices Equip: "equip", Unequip: "unequip", Back: "back"
        end



        case i 
            when "equip"
                hero.equip(inv_arr)
            when "unequip"
                hero.unequip(inv_arr)
            when "back"
                Menu.playing user 
        end 
    end

    def self.shop(user)
        puts "You have: #{user.hero.money} Gold Dragons"

        prompt = TTY::Prompt.new
        i = prompt.select("Please select one.") do |menu|
            menu.choices Buy: "buy", Sell: "sell", "View Stock" => "view", Back: "back"
        end

        case i 
            when "buy"
                item_type(user)

            when "sell"
                
            when "view"
                stock
            when "back"
                Menu.playing user
        end 
        Menu.shop(user)
    end

    def self.stock
        puts `clear`
        Item.all.each do |item|
            puts "#{item.material.capitalize} #{item.item_type.capitalize}      -       #{item.price} Gold Dragons"
        end
    end

    def self.item_type(user)
        puts `clear`
        prompt = TTY::Prompt.new
        choice = prompt.select("What would you like to purchase?") do |menu|
            menu.choices Swords: "sword", Shields: "shield", Armor: "armor", Boots: "boots", Gauntlets: "gauntlets", Helmets: "helmet", Back: "back"
        end
        Menu.shop user if choice == "back"
        material_menu(user, choice)
    end

    def self.material_menu(user, choice)
        
        prompt = TTY::Prompt.new
        material = prompt.select("Material Type:") do |menu|
            menu.choices Wood: "wood", Steel: "steel", Adamantium: "adamantium", Back: "back"
        end
        item_type user if material == "back"
        selected_item = Item.find_by(material: material, item_type: choice)
        buy(user, selected_item)
=======
    user = User.create name: name
    new_hero user.id
    user
end

def new_hero id
  puts "What would you like to name your new hero?"
  name = gets.chomp
  Hero.create name: name, user_id: id
end

def play_menu(hero)
    prompt = TTY::Prompt.new
    i = prompt.select("Welcome, #{hero.name}.") do |menu|
        menu.choices Fight: "fight", Inventory: "inventory", Shop: "shop", "Sign out" => "exit"
>>>>>>> 87d85ad0d7d228298116452c86d1c594be190697
    end

    case i
        when "fight"
            hero.fight
            play_menu hero
        when "inventory"
            hero.view_items
            play_menu hero
        when "shop"
            hero.shop
            play_menu hero
        when "exit"
            main
    end
end
