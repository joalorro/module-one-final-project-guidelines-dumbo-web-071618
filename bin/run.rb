require_relative '../config/environment'

# binding.pry

#welcome message
puts "Please enter your name:"
name = gets.chomp
if User.find_by(name: name)
  ## Direct user to their hero & their hero menu
  puts "hi #{name}"
else
  ## Direct user to create a new hero
  puts "We don't have your name on profile, so we will create one for you!"

  #call Hero.create to make a new hero
  puts "What would you like to name your hero?"
  hero_name = gets.chomp
  Hero.create name: hero_name, user_id: (User.create(name: name)).id
end
# Next Menu with options: #
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



end

binding.pry
puts "HELLO WORLD"
