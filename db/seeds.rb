# user1 = User.create name: "Amirata"
# user2 = User.create name: "Josue"

# hero1 = Hero.create name:"A-town",user_id: user1.id
# hero2 = Hero.create name:"J-boogie",user_id: user2.id

goblin = Enemy.create(species: "Goblin")
orc = Enemy.create(species: "Orc")
swamp_monster = Enemy.create(species: "Swamp Monster")
dark_elf = Enemy.create(species: "Dark Elf")
giant_spider = Enemy.create(species: "Giant Spider")
evil_wizard = Enemy.create(species: "Evil Wizard")

#type,point_value,price, material
wood_sword = Item.create(item_type:"weapon",point_value:"15",price:10,material:"wood")
wood_shield = Item.create(item_type:"shield",point_value:"15",price:10,material:"wood")
wood_armor = Item.create(item_type:"armor",point_value:"15",price:10,material:"wood")
wood_boots = Item.create(item_type:"boots",point_value:"15",price:10,material:"wood")
wood_gauntlets = Item.create(item_type:"gauntlets",point_value:"15",price:10,material:"wood")
wood_helmet = Item.create(item_type:"helmet",point_value:"15",price:10,material:"wood")