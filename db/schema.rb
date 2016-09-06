# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160906140553) do

  create_table "adoptions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "pet_type"
    t.string   "breed"
    t.integer  "age"
    t.string   "description"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "imageurl"
    t.string   "smallimageurl"
  end

  create_table "comments", force: :cascade do |t|
    t.string  "comment_message"
    t.integer "user_id"
    t.integer "post_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "conversations", ["recipient_id"], name: "index_conversations_on_recipient_id"
  add_index "conversations", ["sender_id"], name: "index_conversations_on_sender_id"

  create_table "feeds", force: :cascade do |t|
    t.string   "message"
    t.integer  "like_count"
    t.integer  "comment_count"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "report",             default: "--- []\n"
    t.text     "likedby",            default: "--- []\n"
    t.string   "imageurl"
    t.string   "smallimageurl"
    t.decimal  "score"
  end

  add_index "feeds", ["user_id"], name: "index_feeds_on_user_id"

  create_table "follows", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "follower_id"
    t.integer  "following_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.integer  "conversation_id"
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id"
  add_index "messages", ["user_id"], name: "index_messages_on_user_id"

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.decimal  "price"
    t.boolean  "published"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "products", ["user_id"], name: "index_products_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                   default: "",     null: false
    t.string   "encrypted_password",      default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "owner_type",              default: "none"
    t.string   "auth_token",              default: ""
    t.string   "username"
    t.string   "pet_type"
    t.string   "pet_breed"
    t.string   "pet_story"
    t.integer  "story_like_count",        default: 0
    t.float    "lat"
    t.float    "lng"
    t.string   "imageurl"
    t.string   "city"
    t.integer  "followers",               default: 0
    t.string   "pet_name"
    t.integer  "pet_age"
    t.string   "pet_breeding"
    t.string   "profilepic_file_name"
    t.string   "profilepic_content_type"
    t.integer  "profilepic_file_size"
    t.datetime "profilepic_updated_at"
    t.string   "header_file_name"
    t.string   "header_content_type"
    t.integer  "header_file_size"
    t.datetime "header_updated_at"
    t.string   "headerurl"
    t.string   "notifications"
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
