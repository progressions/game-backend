class CreateConnections < ActiveRecord::Migration[8.0]
  def change
    create_table :connections, id: :uuid do |t|
      t.references :from_room, type: :uuid, null: false, foreign_key: { to_table: :rooms }
      t.references :to_room, type: :uuid, null: true, foreign_key: { to_table: :rooms }
      t.string :label, null: false
      t.string :description, null: true
      t.timestamps
    end
  end
end
