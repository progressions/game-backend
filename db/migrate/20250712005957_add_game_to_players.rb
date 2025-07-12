class AddGameToPlayers < ActiveRecord::Migration[8.0]
  def change
    add_reference :players, :game, type: :uuid, null: true, foreign_key: true
  end
end
