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

ActiveRecord::Schema.define(:version => 20130626161645) do

  create_table "boostify_charities", :force => true do |t|
    t.integer  "boost_id"
    t.string   "title"
    t.string   "name"
    t.string   "url"
    t.string   "short_description"
    t.text     "description"
    t.string   "logo"
    t.integer  "advocates",         :default => 0
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.integer  "sort_order"
    t.integer  "income_cents",      :default => 0,     :null => false
    t.string   "income_currency",   :default => "EUR", :null => false
  end

  add_index "boostify_charities", ["sort_order"], :name => "index_boostify_charities_on_sort_order"

  create_table "boostify_donations", :force => true do |t|
    t.integer  "donatable_id"
    t.integer  "charity_id"
    t.string   "status"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "amount_cents",        :default => 0,     :null => false
    t.string   "amount_currency",     :default => "EUR", :null => false
    t.integer  "commission_cents",    :default => 0,     :null => false
    t.string   "commission_currency", :default => "EUR", :null => false
    t.integer  "user_id"
  end

  add_index "boostify_donations", ["charity_id"], :name => "index_boostify_donations_on_charity_id"
  add_index "boostify_donations", ["donatable_id"], :name => "index_boostify_donations_on_donatable_id"
  add_index "boostify_donations", ["user_id"], :name => "index_boostify_donations_on_user_id"

  create_table "transactions", :force => true do |t|
    t.integer "my_amount_cents",        :default => 0,     :null => false
    t.string  "my_amount_currency",     :default => "USD", :null => false
    t.integer "my_commission_cents",    :default => 0,     :null => false
    t.string  "my_commission_currency", :default => "USD", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
