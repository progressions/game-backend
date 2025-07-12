# db/seeds.rb
# Create themes using find_or_create_by
Theme.find_or_create_by(name: 'fantasy') do |theme|
  theme.description = 'A world of magic and mystery, filled with enchanted forests and ancient ruins.'
end
Theme.find_or_create_by(name: 'action') do |theme|
  theme.description = 'A high-energy world of danger and excitement, with urban rooftops and crumbling hideouts.'
end
Theme.find_or_create_by(name: 'adventure') do |theme|
  theme.description = 'A vast world of exploration, with rugged jungles, windswept cliffs, and hidden temples.'
end

# Create a user using find_or_create_by
user = User.find_or_create_by(email: 'test@example.com') do |u|
  u.password = 'password123'  # has_secure_password will hash it
end

# Create a game for the user with fantasy theme
fantasy_theme = Theme.find_by(name: 'fantasy')
game = Game.find_or_create_by(user: user, theme: fantasy_theme)

# Create fantasy-themed rooms associated with the game
room1 = Room.find_or_create_by(title: 'Twilight Hollow', game: game) do |room|
  room.description = 'A stone chamber glowing faintly under moonlight, with vines creeping along cracked walls.'
end

room2 = Room.find_or_create_by(title: 'Mossy Glade', game: game) do |room|
  room.description = 'A clearing where glowing flowers bloom under an ancient oak, whispering secrets of old magic.'
end

room3 = Room.find_or_create_by(title: 'Starlit Ruins', game: game) do |room|
  room.description = 'Crumbling stone arches stand under a starry sky, etched with runes pulsing faintly.'
end

# Create connections for fantasy rooms
Connection.find_or_create_by(from_room: room1, label: 'Mossy Trail') do |conn|
  conn.to_room = room2
  conn.description = 'A winding path of soft moss under tangled branches.'
end

Connection.find_or_create_by(from_room: room1, label: 'Rune Gate') do |conn|
  conn.to_room = room3
  conn.description = 'A stone archway glowing with faint, magical runes.'
end

Connection.find_or_create_by(from_room: room2, label: 'Shadowy Path') do |conn|
  conn.to_room = room1
  conn.description = 'A dark trail leading back through dense foliage.'
end

Connection.find_or_create_by(from_room: room2, label: 'Glowing Stream') do |conn|
  conn.to_room = room3
  conn.description = 'A shimmering stream reflecting starlight, winding through trees.'
end

Connection.find_or_create_by(from_room: room3, label: 'Ancient Steps') do |conn|
  conn.to_room = room1
  conn.description = 'Worn stone steps descending into a misty hollow.'
end

Connection.find_or_create_by(from_room: room3, label: 'Crystal Passage') do |conn|
  conn.to_room = nil
  conn.description = 'A tunnel lined with faintly glowing crystals.'
end