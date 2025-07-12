# db/seeds.rb
# Create themes using find_or_create_by to avoid duplicates
Theme.find_or_create_by(name: 'fantasy') do |theme|
  theme.description = 'A world of magic and mystery, filled with enchanted forests and ancient ruins.'
end
Theme.find_or_create_by(name: 'action') do |theme|
  theme.description = 'A high-energy world of danger and excitement, with urban rooftops and crumbling hideouts.'
end
Theme.find_or_create_by(name: 'adventure') do |theme|
  theme.description = 'A vast world of exploration, with rugged jungles, windswept cliffs, and hidden temples.'
end

# Create fantasy-themed rooms using find_or_create_by
room1 = Room.find_or_create_by(title: 'Twilight Hollow') do |room|
  room.description = 'A stone chamber glowing faintly under moonlight, with vines creeping along cracked walls.'
end

room2 = Room.find_or_create_by(title: 'Mossy Glade') do |room|
  room.description = 'A clearing where glowing flowers bloom under an ancient oak, whispering secrets of old magic.'
end

room3 = Room.find_or_create_by(title: 'Starlit Ruins') do |room|
  room.description = 'Crumbling stone arches stand under a starry sky, etched with runes pulsing faintly.'
end

# Create connections for fantasy rooms using find_or_create_by
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