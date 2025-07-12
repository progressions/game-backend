class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players, id: :uuid do |t|
      t.references :current_room, type: :uuid, null: false, foreign_key: { to_table: :rooms }
      t.timestamps
    end
  end
end
