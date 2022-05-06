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

ActiveRecord::Schema[7.0].define(version: 2022_04_23_215647) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_zones", force: :cascade do |t|
    t.string "aid"
    t.string "type"
    t.integer "zone1"
    t.integer "zone2"
    t.integer "zone3"
    t.integer "zone4"
    t.integer "zone5"
    t.integer "zone6"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_activity_zones_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name", default: "Anonymous", null: false
    t.string "location"
    t.string "image"
    t.string "provider"
    t.string "uid"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  add_foreign_key "activity_zones", "users"
end
