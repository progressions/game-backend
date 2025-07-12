class AddTitleToGame < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :title, :string
  end
end
