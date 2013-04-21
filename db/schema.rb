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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130421210127) do

  create_table "admins", :force => true do |t|
    t.string "username"
    t.string "hashed_password"
    t.string "salt"
  end

  create_table "boardgames", :force => true do |t|
    t.string  "name"
    t.string  "bgg_rating"
    t.string  "user_rating"
    t.string  "num_votes"
    t.string  "bgg_id"
    t.string  "year_published"
    t.integer "min_num_players"
    t.integer "max_num_players"
    t.integer "playing_time"
    t.string  "image_url"
    t.string  "image_file_name"
    t.string  "image_file_size"
    t.string  "image_content_type"
    t.string  "image_updated_at"
    t.text    "desc"
    t.integer "age"
    t.decimal "gbg_rating",         :precision => 8, :scale => 2
    t.string  "price"
    t.string  "amazon_url"
  end

  create_table "categories", :force => true do |t|
    t.integer "boardgame_id"
    t.string  "category_value"
  end

  create_table "honours", :force => true do |t|
    t.integer "boardgame_id"
    t.string  "honour_value"
  end

  create_table "mechanics", :force => true do |t|
    t.integer "boardgame_id"
    t.string  "mechanic_value"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.boolean  "published"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "subdomains", :force => true do |t|
    t.integer "boardgame_id"
    t.string  "subdomain_value"
  end

end
