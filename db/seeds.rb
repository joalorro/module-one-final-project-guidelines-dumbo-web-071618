user1 = User.create name: "Amirata"
user2 = User.create name: "Josue"

hero1 = Hero.create name:"A-town",user_id: user1.id
hero2 = Hero.create name:"J-boogie",user_id: user2.id
