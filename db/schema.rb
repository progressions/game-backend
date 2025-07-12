# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_12_221612) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "connections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "from_room_id"
    t.uuid "to_room_id"
    t.string "label", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_room_id"], name: "index_connections_on_from_room_id"
    t.index ["to_room_id"], name: "index_connections_on_to_room_id"
  end

  create_table "games", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "theme_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.uuid "starting_room_id"
    t.index ["theme_id"], name: "index_games_on_theme_id"
    t.index ["user_id"], name: "index_games_on_user_id"
  end

  create_table "player_histories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "player_id", null: false
    t.uuid "room_id", null: false
    t.datetime "visited_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "game_id"
    t.index ["game_id"], name: "index_player_histories_on_game_id"
    t.index ["player_id"], name: "index_player_histories_on_player_id"
    t.index ["room_id"], name: "index_player_histories_on_room_id"
  end

  create_table "players", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "current_room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "game_id"
    t.index ["current_room_id"], name: "index_players_on_current_room_id"
    t.index ["game_id"], name: "index_players_on_game_id"
  end

  create_table "rooms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "game_id"
    t.index ["game_id"], name: "index_rooms_on_game_id"
  end

  create_table "themes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "connections", "rooms", column: "from_room_id"
  add_foreign_key "connections", "rooms", column: "to_room_id"
  add_foreign_key "games", "rooms", column: "starting_room_id"
  add_foreign_key "games", "themes"
  add_foreign_key "games", "users"
  add_foreign_key "player_histories", "games"
  add_foreign_key "player_histories", "players"
  add_foreign_key "player_histories", "rooms"
  add_foreign_key "players", "games"
  add_foreign_key "players", "rooms", column: "current_room_id"
  add_foreign_key "rooms", "games"
end
