
tim = User.create(name: "Tim", age: 23, location: "New York")
alex = User.create(name: "Alex", age: 32, location: "New York")
steve = User.create(name: "Steve", age: 25, location: "Miami")
jeff = User.create(name: "Jeff", age: 18, location: "Los Angeles")
alexis = User.create(name: "Alexis", age: 27, location: "Baltimore")

yeezus = Album.create(title: "Yeezus", artist: "Kanye West", genre: "Hip-hop", label: "GOOD music")
astroworld = Album.create(title: "Astroworld", artist: "Travis Scott", genre: "Hip-hop", label: "Grand Hustle")
the_blueprint = Album.create(title: "The Blueprint", artist: "Jay-z", genre: "Hip-hop", label: "Roc-a-fella")
anti = Album.create(title: "ANTI", artist: "Rihanna", genre: "Pop", label: "Roc-a-fella")
penetration_testing = Album.create(title: "Penetration Testing", artist: "Leonce", genre: "Techno", label: "Night Slugs")
beatbox = Album.create(title: "Beatbox", artist: "Los", genre: "Footwork", label: "JukeBounceWerk")
we_get_the_world = Album.create(title: "We Get The World We Deserve", artist: "Junky Palms", genre: "Techno", label: "Self Released")

Collection.create(user: tim, album: yeezus)
Collection.create(user: alex, album: beatbox)
Collection.create(user: steve, album: anti)




