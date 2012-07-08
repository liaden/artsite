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

ActiveRecord::Schema.define(:version => 20120708012400) do

  create_table "addresses", :force => true do |t|
    t.string   "recipient"
    t.string   "line1"
    t.string   "line2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "artwork_media", :force => true do |t|
    t.integer "medium_id"
    t.integer "artwork_id"
  end

  create_table "artwork_tags", :force => true do |t|
    t.integer "artwork_id"
    t.integer "tag_id"
  end

  create_table "artworks", :force => true do |t|
    t.string   "title"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "description"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.string   "image_file_size"
    t.string   "slug"
  end

  add_index "artworks", ["slug"], :name => "index_artworks_on_slug", :unique => true

  create_table "default_prices", :force => true do |t|
    t.string  "dimension"
    t.string  "material"
    t.decimal "price"
  end

  create_table "lesson_orders", :force => true do |t|
    t.integer  "lesson_id"
    t.integer  "order_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lessons", :force => true do |t|
    t.string   "name"
    t.datetime "date"
    t.integer  "free_spots"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "media", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "state"
    t.string   "charge_id"
    t.string   "guest_email"
    t.datetime "placed_at"
    t.integer  "address_id"
  end

  create_table "print_orders", :force => true do |t|
    t.integer  "print_id"
    t.integer  "order_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "frame_size"
  end

  create_table "prints", :force => true do |t|
    t.boolean  "is_sold_out"
    t.boolean  "is_on_show"
    t.integer  "artwork_id"
    t.string   "size_name"
    t.string   "material"
    t.string   "dimensions"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.decimal  "price"
  end

  create_table "shows", :force => true do |t|
    t.string   "name"
    t.datetime "date"
    t.string   "building"
    t.string   "address"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "show_type"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "persistence_token"
    t.integer  "privilege"
    t.integer  "address_id"
  end

end
