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
    prompt = TTY::Prompt.new
    i = prompt.select("Welcome, #{hero.name}.") do |menu|
        menu.choices  Fight: "fight",
                      Stats: "stats",
                      Inventory: "inventory",
                      Shop: "shop",
                      "Sign Out" => "exit"
    end

    case i
        when "fight"
          hero.fight
          play_menu hero
        when "stats"
          hero.display_stats
        when "inventory"
          puts `clear`
          hero.view_items
        when "shop"
          puts `clear`
          hero.shop
        when "exit"
          main
    end
end

def generate_menu menu_hash
  menu_hash[:message] = "" if menu_hash[:message].nil?
  choice = TTY::Prompt.new.select(menu_hash[:message]) do |menu|
    menu.choices menu_hash[:options]
  end
  choice
end
