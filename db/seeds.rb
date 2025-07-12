# Create or find a sample user
user = User.find_or_create_by!(email: "test@example.com") do |u|
  u.password = "password123"
end

# Create or find a sample theme with description
theme = Theme.find_or_create_by!(name: "Fantasy") do |t|
  t.description = "A magical world of dragons, wizards, and enchanted forests."
end

# Create or find a sample game
game = Game.find_or_create_by!(title: "Forest Adventure") do |g|
  g.theme = theme
  g.user = user
end

# Create or find rooms
room1 = game.rooms.find_or_create_by!(title: "Clearing") do |r|
  r.description = "A sunny clearing in the forest."
end
room2 = game.rooms.find_or_create_by!(title: "Cave") do |r|
  r.description = "A dark, damp cave."
end
room3 = game.rooms.find_or_create_by!(title: "Riverbank") do |r|
  r.description = "A peaceful riverbank."
end

# Set starting room if not already set
game.update!(starting_room: room1) unless game.starting_room_id

# Create connections if they don't exist
Connection.find_or_create_by!(from_room: room1, to_room: room2, label: "Mossy Trail")
Connection.find_or_create_by!(from_room: room1, to_room: room3, label: "River Path")
