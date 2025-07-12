class CreatePlayerHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :player_histories, id: :uuid do |t|
      t.references :player, type: :uuid, null: false, foreign_key: true
      t.references :room, type: :uuid, null: false, foreign_key: true
      t.datetime :visited_at, null: false
      t.timestamps
    end
  end
end
