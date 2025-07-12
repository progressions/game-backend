class AddStartingRoomIdToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :starting_room_id, :uuid
    add_foreign_key :games, :rooms, column: :starting_room_id
  end
end
