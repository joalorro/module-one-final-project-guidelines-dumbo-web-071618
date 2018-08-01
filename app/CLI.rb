module Menu
    def self.main
        puts `clear`
        prompt = TTY::Prompt.new
        i = prompt.select("Welcome to the game of .. ") do |menu|
            menu.choices Login: "login", "Sign up": "signup", Exit: "exit"
        end

        case i
            when "login"
                self.login
            when "signup"
                self.signup
                user = User.all.last
                self.playing user
            when "exit"
                puts "Thanks fo playin sucka"
                Menu.exit
        end
    end

    def self.login
        puts "Please enter your username"
        name = gets.chomp
        if !User.find_by(name: name)
            ## Direct user to create a new hero
            puts "We don’t have your name on profile, so we will create one for you!"
            
            # Call on signup
            self.signup(name: name)    
        end
        # binding.pry
        user = User.find_by(name: name)
        self.playing(user)
    end

    def self.signup(name: nil)
        if name.nil?
            puts "Please enter your new username"
            name = gets.chomp
        end
        if !User.find_by(name: name)
            User.create(name: name)
            self.create_hero(name)
        end
        
    end

    def self.create_hero(name)
        puts "What would you like to name your hero?"
        hero_name = gets.chomp
        Hero.create name: hero_name, user_id: (User.find_by(name: name)).id
    end

    def self.playing(user)
        
        prompt = TTY::Prompt.new
        i = prompt.select("Welcome to the game of .. ") do |menu|
            menu.choices Fight: "fight", Inventory: "inventory", Shop: "shop", "Sign out" => "exit"
        end
        
        case i
            when "fight"
                user.hero.fight
                Menu.playing user
            when "inventory"
                self.inventory(user)
                
            when "shop"
                self.shop(user)

            when "exit"
                Menu.main 
        end
    end

    def self.inventory(user) 
        puts `clear`
        hero = user.hero

        view_items hero

    end

    def self.view_items hero 
        # hero.inventories.each do |inv|
        #     puts "#{inv.item.name}"
        # end 
        hash = {}
        hero.inventories.each do |inv|
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

        item_arr = TTY::Prompt.new.select("Your inventory") do |menu|
            menu.choices hashe
        end
        inv_actions(hero, item_arr)

    end

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
    end

    def self.buy(user, item)
        
        if item.price > user.hero.money
            puts `clear`
            puts "Sorry, you can't afford this."
            puts "You need #{item.price - user.hero.money} more gold dragons in order to purchase this #{item.name}."
        else
            i = Inventory.create
            i.hero = user.hero
            i.item = item
            i.equip = false
            user.hero.money -= item.price
            i.save
            user.hero.save
            puts `clear`
            puts "Thank you for you custom."
        end
    end
end