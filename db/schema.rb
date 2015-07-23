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

ActiveRecord::Schema.define(version: 20150720092939) do

  create_table "adj_assignments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "tournament_id"
    t.integer  "round_id"
    t.integer  "room_draw_id"
    t.boolean  "chair"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "adjudicators", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "room_draw_id"
    t.boolean  "chair"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tournament_id"
  end

  create_table "allocations", force: :cascade do |t|
    t.integer  "tournament_id"
    t.integer  "institution_id"
    t.integer  "num_teams"
    t.integer  "num_adjs"
    t.boolean  "live"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_posts", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conflicts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "institution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "institutions", force: :cascade do |t|
    t.string   "short_name",   limit: 255
    t.string   "full_name",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_members"
  end

  create_table "motion_genres", force: :cascade do |t|
    t.integer  "motion_id"
    t.integer  "genre_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "motions", force: :cascade do |t|
    t.string   "wording",         limit: 255
    t.integer  "user_id"
    t.integer  "tournament_id"
    t.integer  "round_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "motion_genre_id"
  end

  create_table "room_draws", force: :cascade do |t|
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

  create_table "rooms", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "location",       limit: 255
    t.string   "remarks",        limit: 255
    t.integer  "institution_id"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rounds", force: :cascade do |t|
    t.integer  "tournament_id"
    t.integer  "motion_id"
    t.string   "start_time",    limit: 255
    t.string   "end_prep_time", limit: 255
    t.integer  "status"
    t.integer  "round_num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scores", force: :cascade do |t|
    t.integer  "tournament_id"
    t.integer  "round_id"
    t.integer  "user_id"
    t.float    "speaks"
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.integer  "institution_id"
    t.integer  "tournament_id"
    t.integer  "member_1_id"
    t.integer  "member_2_id"
    t.float    "total_speaks"
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tournament_attendees", force: :cascade do |t|
    t.integer  "tournament_id"
    t.integer  "user_id"
    t.integer  "role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "rating"
    t.integer  "institution_id"
  end

  create_table "tournament_settings", force: :cascade do |t|
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

  create_table "tournaments", force: :cascade do |t|
    t.string   "name",                  limit: 255
    t.integer  "institution_id"
    t.string   "location",              limit: 255
    t.string   "start_time",            limit: 255
    t.string   "end_time",              limit: 255
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

  create_table "users", force: :cascade do |t|
    t.string   "fname",                  limit: 255
    t.string   "lname",                  limit: 255
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "remember_token",         limit: 255
    t.integer  "institution_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
