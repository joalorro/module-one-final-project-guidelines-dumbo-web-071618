def main
    i = TTY::Prompt.new.select("Welcome to the land with no name.") do |menu|
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
    pastel = Pastel.new
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
    if !user.hero.nil?
      hero = user.hero
    else
      hero = new_hero user.id
    end

    i = 0.0
    str = "Traversing the multi-verse"
    loop do
      if i == 2 || i == 5
        print pastel.decorate(str,:magenta) + "." * i + "\r"
      elsif i == 1 || i == 4
        print pastel.decorate(str,:bright_black) + "." * i + "\r"
      elsif i == 3
        print pastel.decorate(str,:cyan) + "." * i + "\r"
      else
        j = rand(1..3)
        print pastel.decorate(str,:yellow) + "." * i + "\r" if j == 1
        print pastel.decorate(str,:red) + "." * i + "\r" if j == 2
        print pastel.decorate(str,:green) + "." * i + "\r" if j == 3
      end
      $stdout.flush
      i += 0.5
      sleep 0.5
      break if i == 6
    end
    puts `clear`
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
    hero = Hero.find(hero.id)
    choice = generate_menu  message:"#{hero.name}..",
                            options: {
                  Fight: "fight",
                  "Fight History" => "fight_history",
                  Stats: "stats",
                  Inventory: "inventory",
                  Shop: "shop",
                  Options: "options",
                  "Sign Out" => "exit"
                }
    case choice
      when "fight"
        hero.fight_enemy
        play_menu hero
      when "stats"
        hero.display_stats
      when "fight_history"
        puts `clear`
        hero.display_fight_history
        play_menu hero
      when "inventory"
        puts `clear`
        hero.view_items
      when "shop"
        puts `clear`
        hero.shop
      when "options"
        puts `clear`
        options_menu hero
      when "exit"
        main
    end
end

def options_menu hero
  choice = generate_menu options: {
    "Rename Hero" => "rename",
    "Delete hero" => "delete",
    Back: "back"
  }
  case choice
  when "rename"
    rename_hero hero
    play_menu hero
  when "delete"
    delete_hero hero
    main
  when "back"
    play_menu hero
  end
end

def rename_hero hero
  puts "What would you like to rename your hero?"
  name = gets.chomp
  hero.name = name
  hero.save
  puts `clear`
end

def delete_hero hero
  puts `clear`
  puts "#{hero.name} has been successfully deleted."
  Hero.delete hero
end

def generate_menu menu_hash
  menu_hash[:message] = "" if menu_hash[:message].nil?
  choice = TTY::Prompt.new.select(menu_hash[:message]) do |menu|
    menu.choices menu_hash[:options]
  end
  choice
end

def generate_menu_options_from_inventory hero
  options = hero.get_equipped_objects.each do |inv_object|
    options_hash[inv_object.item.name.to_sym] = [inv_object.item, inv.object]
  end
  options
end

def generate_menu_of_selected_item_type item_type
  options_hash = {}
  if !self.inventories.empty?
    self.inventories.select do |inv|
      inv.hero_id == self.id && inv.item.item_type == item_type
    end.map do |inv|
      inv.item
    end.each do |item|
      options_hash[item.name.to_sym] = item
    end
  end
  if options_hash.empty? || self.inventories.empty?
    options_hash[:Back] = "back"
    message = "You don't seem to have anything here."
  end
  generate_menu message: message, options: options_hash
end

def delay

end 
