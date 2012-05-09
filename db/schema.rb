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

ActiveRecord::Schema.define(:version => 20120508220119) do

  create_table "appointments", :force => true do |t|
    t.string   "name"
    t.integer  "party"
    t.integer  "wait"
    t.boolean  "seated"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "phone"
    t.integer  "restaurant_id"
    t.integer  "customer_id"
    t.boolean  "done"
    t.datetime "seated_at"
    t.string   "location"
  end

  create_table "customers", :force => true do |t|
    t.integer  "phone"
    t.string   "name"
    t.string   "email"
    t.integer  "zipcode"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "drinks", :force => true do |t|
    t.text     "content"
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "foods", :force => true do |t|
    t.text     "content"
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "layouts", :force => true do |t|
    t.integer  "restaurant_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "restaurant_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "food_id"
    t.integer  "drink_id"
    t.integer  "deal_id"
    t.integer  "general_id"
  end

  create_table "restaurants", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "twitter_id"
  end

  create_table "table_types", :force => true do |t|
    t.integer  "layout_id"
    t.integer  "size"
    t.integer  "quantity"
    t.float    "turnover"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "location"
  end

end
