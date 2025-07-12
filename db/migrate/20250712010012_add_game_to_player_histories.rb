class AddGameToPlayerHistories < ActiveRecord::Migration[8.0]
  def change
    add_reference :player_histories, :game, type: :uuid, null: true, foreign_key: true
  end
end
