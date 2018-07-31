require_relative '../config/environment'
# binding.pry
# First menu with welcome message
i = Menu.main
# Move on to the next menu
case i
  when "login"
    Menu.login
  when "signup"
    puts "Please enter your new username"
    name = gets.chomp
    Menu.signup name
    user = User.all.last
    Menu.playing user
  when "exit"
    Menu.exit
end


## Fight random enemy
## Look into your inventory
## Look at shop
## quit

## if quit --> output quitting message & terminate session
## if shop --> bring up the list of items
## if inventory --> hero.items && include hero's current money value
## if fight random enemy -->
  ## create a new instance of the Fight class && make a random Enemy instance
  ## generate Enemy's FP & calculate user's winning chance
  ## based on that probability, determine outcome of fight
    ## if win --> give player exp & money
    ## if lose --> give player less exp & no money
## when fight is finished, call on #level_up to see if exp return to hero's menu
