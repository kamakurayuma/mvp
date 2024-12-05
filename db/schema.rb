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

ActiveRecord::Schema[8.0].define(version: 2024_11_28_035002) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "boards", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "board_image"
    t.string "camera_make"
    t.string "camera_model"
    t.string "image_url"
    t.bigint "camera_id", null: false
    t.string "custom_camera_make"
    t.bigint "camera_model_id"
    t.index ["camera_id"], name: "index_boards_on_camera_id"
    t.index ["camera_model_id"], name: "index_boards_on_camera_model_id"
    t.index ["user_id"], name: "index_boards_on_user_id"
  end

  create_table "camera_models", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_camera_models_on_name", unique: true
  end

  create_table "cameras", force: :cascade do |t|
    t.string "make"
    t.string "model"
    t.boolean "unknown"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "user_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar"
    t.text "bio"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "boards", "camera_models"
  add_foreign_key "boards", "cameras"
  add_foreign_key "boards", "users"
end
