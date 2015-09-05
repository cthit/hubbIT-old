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

ActiveRecord::Schema.define(version: 20150905132302) do

  create_table "api_keys", force: true do |t|
    t.string   "access_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "comment"
  end

  create_table "hour_entries", force: true do |t|
    t.string   "cid"
    t.date     "date"
    t.integer  "hour"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mac_addresses", id: false, force: true do |t|
    t.string   "address"
    t.string   "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mac_addresses", ["user_id"], name: "index_mac_addresses_on_user_id", using: :btree

  create_table "sessions", force: true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "mac_address"
    t.string   "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["user_id"], name: "index_sessions_on_user_id", using: :btree

  create_table "user_sessions", force: true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_sessions", ["user_id"], name: "index_user_sessions_on_user_id", using: :btree

  create_table "users", id: false, force: true do |t|
    t.string   "cid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users_total_time", id: false, force: true do |t|
    t.integer "id",                                  default: 0, null: false
    t.string  "user_id"
    t.decimal "total_time", precision: 42, scale: 0
  end

end
