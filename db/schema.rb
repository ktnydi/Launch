# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_24_133523) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_analyses", force: :cascade do |t|
    t.string "article_token", null: false
    t.string "access_source", null: false
    t.string "user_token", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bookmarks", force: :cascade do |t|
    t.string "user_token", null: false
    t.string "article_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string "user_token", null: false
    t.string "article_token", null: false
    t.string "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drafts", force: :cascade do |t|
    t.string "article_token"
    t.string "title"
    t.string "category"
    t.text "content"
    t.string "user_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entries", force: :cascade do |t|
    t.string "entry_token"
    t.integer "status", default: 0, null: false
    t.string "title", default: "", null: false
    t.string "tag", default: ""
    t.text "content", default: ""
    t.string "user_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["entry_token"], name: "index_entries_on_entry_token", unique: true
  end

  create_table "follows", force: :cascade do |t|
    t.string "following_user_id"
    t.string "followed_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.string "filename"
    t.binary "file"
    t.string "user_token", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_token"], name: "index_images_on_user_token"
  end

  create_table "likes", force: :cascade do |t|
    t.string "user_token", null: false
    t.string "article_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "publics", force: :cascade do |t|
    t.string "article_token", null: false
    t.string "title", null: false
    t.string "category", null: false
    t.text "content", null: false
    t.string "user_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "access_analyses_count", default: 0, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nickname"
    t.string "uid"
    t.string "provider"
    t.string "name", default: "", null: false
    t.string "uuid", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
