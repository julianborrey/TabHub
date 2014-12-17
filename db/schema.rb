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

ActiveRecord::Schema.define(version: 20141014034710) do

  create_table "adj_assignments", force: true do |t|
    t.integer  "user_id"
    t.integer  "tournament_id"
    t.integer  "round_id"
    t.integer  "room_draw_id"
    t.boolean  "chair"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "adjudicators", force: true do |t|
    t.integer  "user_id"
    t.integer  "room_draw_id"
    t.boolean  "chair"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tournament_id"
  end

  create_table "allocations", force: true do |t|
    t.integer  "tournament_id"
    t.integer  "institution_id"
    t.integer  "num_teams"
    t.integer  "num_adjs"
    t.boolean  "live"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conflicts", force: true do |t|
    t.integer  "user_id"
    t.integer  "institution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "institutions", force: true do |t|
    t.string   "short_name"
    t.string   "full_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_members"
  end

  create_table "motions", force: true do |t|
    t.string   "wording"
    t.integer  "user_id"
    t.integer  "tournament_id"
    t.integer  "round_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "room_draws", force: true do |t|
    t.integer  "tournament_id"
    t.integer  "round_id"
    t.integer  "room_id"
    t.integer  "og_id"
    t.integer  "oo_id"
    t.integer  "cg_id"
    t.integer  "co_id"
    t.integer  "first_id"
    t.integer  "second_id"
    t.integer  "third_id"
    t.integer  "fourth_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rooms", force: true do |t|
    t.string   "name"
    t.string   "location"
    t.string   "remarks"
    t.integer  "institution_id"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rounds", force: true do |t|
    t.integer  "tournament_id"
    t.integer  "motion_id"
    t.string   "start_time"
    t.string   "end_prep_time"
    t.integer  "status"
    t.integer  "round_num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scores", force: true do |t|
    t.integer  "tournament_id"
    t.integer  "round_id"
    t.integer  "user_id"
    t.float    "speaks"
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: true do |t|
    t.string   "name"
    t.integer  "institution_id"
    t.integer  "tournament_id"
    t.integer  "member_1_id"
    t.integer  "member_2_id"
    t.float    "total_speaks"
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tournament_attendees", force: true do |t|
    t.integer  "tournament_id"
    t.integer  "user_id"
    t.integer  "role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "rating"
    t.integer  "institution_id"
  end

  create_table "tournament_settings", force: true do |t|
    t.integer  "format"
    t.integer  "registration"
    t.integer  "motion"
    t.integer  "tab"
    t.integer  "attendees"
    t.integer  "teams"
    t.integer  "privacy"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tournament_id"
  end

  create_table "tournaments", force: true do |t|
    t.string   "name"
    t.integer  "institution_id"
    t.string   "location"
    t.string   "start_time"
    t.string   "end_time"
    t.text     "remarks"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status"
    t.integer  "tournament_setting_id"
    t.integer  "region"
    t.text     "rooms"
    t.integer  "round_counter"
    t.float    "progress"
  end

  create_table "users", force: true do |t|
    t.string   "fname"
    t.string   "lname"
    t.string   "email",                  default: "", null: false
    t.string   "remember_token"
    t.integer  "institution_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
