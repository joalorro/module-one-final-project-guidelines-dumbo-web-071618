#Enemy Seeds
#Tier 1
goblin = Enemy.create(species: "Goblin", tier: 1)
orc = Enemy.create(species: "Orc", tier: 1)
swamp_monster = Enemy.create(species: "Swamp Monster", tier: 1)
hob = Enemy.create(species: "Hob", tier: 1)
giant_spider = Enemy.create(species: "Giant Spider", tier: 1)

#Tier 2

uruk_hai = Enemy.create(species: "Uruk-hai Warrior", tier: 2)
dark_elf = Enemy.create(species: "Dark Elf", tier: 2)
wight = Enemy.create(species: "Wight", tier: 2)
hell_hound = Enemy.create(species: "Hell Hound", tier: 2)
sorcerer = Enemy.create(species: "Sorcerer", tier: 2)

#Tier 3
white_walker = Enemy.create(species: "White Walker", tier: 3)
vampire = Enemy.create(species: "Vampire", tier: 3)
rock_elemental = Enemy.create(species: "Rock Elemental", tier: 3)
dragon_priest = Enemy.create(species: "Dragon Priest", tier: 3)
demon = Enemy.create(species: "Demon", tier: 3)

# Tier 4
dragon = Enemy.create(species: "Dragon", tier: 4)
balrog = Enemy.create(species: "Balrog", tier: 4)
lava_golem = Enemy.create(species: "Lava Golem", tier: 4)
hydra = Enemy.create(species: "Hydra", tier: 4)
cerberus = Enemy.create(species: "Cerberus", tier: 4)

#Weapon Seeds
#type,point_value,price, material
iron_sword = Item.create(item_type:"sword",point_value:40,price:20,material:"iron")
iron_shield = Item.create(item_type:"shield",point_value:20,price:20,material:"iron")
iron_armor = Item.create(item_type:"armor",point_value:20,price:20,material:"iron")
iron_boots = Item.create(item_type:"boots",point_value:20,price:20,material:"iron")
iron_gauntlets = Item.create(item_type:"gauntlets",point_value:20,price:20,material:"iron")
iron_helmet = Item.create(item_type:"helmet",point_value:20,price:20,material:"iron")

steel_sword = Item.create(item_type:"sword",point_value:100,price:100,material:"steel")
steel_shield = Item.create(item_type:"shield",point_value:50,price:100,material:"steel")
steel_armor = Item.create(item_type:"armor",point_value:50,price:100,material:"steel")
steel_boots = Item.create(item_type:"boots",point_value:50,price:100,material:"steel")
steel_gauntlets = Item.create(item_type:"gauntlets",point_value:50,price:100,material:"steel")
steel_helmet = Item.create(item_type:"helmet",point_value:50,price:100,material:"steel")

adamantium_sword = Item.create(item_type:"sword",point_value:150,price:500,material:"adamantium")
adamantium_shield = Item.create(item_type:"shield",point_value:75,price:500,material:"adamantium")
adamantium_armor = Item.create(item_type:"armor",point_value:75,price:500,material:"adamantium")
adamantium_boots = Item.create(item_type:"boots",point_value:75,price:500,material:"adamantium")
adamantium_gauntlets = Item.create(item_type:"gauntlets",point_value:75,price:500,material:"adamantium")
adamantium_helmet = Item.create(item_type:"helmet",point_value:75,price:500,material:"adamantium")

mithril_sword = Item.create(item_type:"sword",point_value:200,price: 1000,material:"mithril")
mithril_shield = Item.create(item_type:"shield",point_value:100,price:1000,material:"mithril")
mithril_armor = Item.create(item_type:"armor",point_value:100,price:1000,material:"mithril")
mithril_boots = Item.create(item_type:"boots",point_value:100,price:1000,material:"mithril")
mithril_gauntlets = Item.create(item_type:"gauntlets",point_value:100,price:1000,material:"mithril")
mithril_helmet = Item.create(item_type:"helmet",point_value:100,price:1000,material:"mithril")

dragon_bone_sword = Item.create(item_type:"sword",point_value:450,price: 2500,material:"Dragon Bone")
dragon_bone_shield = Item.create(item_type:"shield",point_value:200,price:2500,material:"Dragon Bone")
dragon_bone_armor = Item.create(item_type:"armor",point_value:200,price:2500,material:"Dragon Bone")
dragon_bone_boots = Item.create(item_type:"boots",point_value:200,price:2500,material:"Dragon Bone")
dragon_bone_gauntlets = Item.create(item_type:"gauntlets",point_value:200,price:2500,material:"Dragon Bone")
dragon_bone_helmet = Item.create(item_type:"helmet",point_value:200,price:2500,material:"Dragon Bone")
