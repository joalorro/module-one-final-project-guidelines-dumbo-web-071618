module Menu
    def self.main
        prompt = TTY::Prompt.new
        i = prompt.select("Welcome to the game of .. ") do |menu|
            menu.choices Login: "login", Signup: "signup", Exit: "exit"
        end
        puts `clear`
        i
    end

    def self.login
        puts "Please enter your username"
        name = gets.chomp
        if !User.find_by(name: name)
            ## Direct user to create a new hero
            puts "We don’t have your name on profile, so we will create one for you!"
           
            # Call on signup
            self.signup(name)
            
        end
        # binding.pry
        user = User.find_by(name: name)

        self.playing(user)
    end

    def self.signup(name)
        puts "What would you like to name your hero?"
        hero_name = gets.chomp
        User.create(name: name)
        Hero.create name: hero_name, user_id: (User.find_by(name: name)).id
    end

    def self.playing(user)
        prompt = TTY::Prompt.new
        i = prompt.select("Welcome to the game of .. ") do |menu|
            menu.choices Fight: "fight", Inventory: "inventory", Shop: "shop",Exit: "exit"
        end
        
        case i
            when "fight"
                (user.heros[0]).fight
        end
    end
end