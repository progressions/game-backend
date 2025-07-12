class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.references :theme, type: :uuid, null: false, foreign_key: true
      t.timestamps
    end
  end
end
