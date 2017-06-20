# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = Category.create([{name: "TV Comedies"}, {name: "TV Dramas"}])

videos = Video.create([{title: "Monk", description: "Adrian Monk is a brilliant
  San Francisco detective, whose obsessive compulsive disorder just happens
  to get in the way.", small_cover_url: "/tmp/monk.jpg",
  large_cover_url: "/tmp/monk_large.jpg", category_id: 1}, {title: "Lost", description: "The 
  survivors of a plane crash are forced to work together in order to survive on
  a seemingly deserted tropical island", small_cover_url: "/tmp/lost.jpg",
  large_cover_url: "/tmp/lost_large.jpg", category_id: 2}
])

users = User.create([{email: "dan@example.com", full_name: "Dan Myers", password: "password"},
{email: "katie@example.com", full_name: "Katie Myers", password: "password"}])

reviews = Review.create([{stars: 5, content: "Awesome show!", video_id: 2, user_id: 1},
{stars: 3, content: "Meh...", video_id: 1, user_id: 2}, 
{stars: 4, content: "Monk is a cool dude.", video_id: 1, user_id: 1}])

queue_positions = QueuePosition.create([{position: 1, user_id: 1, video_id: 1}, {position: 2, user_id: 1, video_id: 2}] )

relationships = Relationship.create([{follower: User.first, leader: User.last}, {follower: User.last, leader: User.first}])


