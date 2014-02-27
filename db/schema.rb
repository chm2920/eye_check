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

ActiveRecord::Schema.define(version: 20140224143940) do

  create_table "admins", force: true do |t|
    t.string "login_name"
    t.string "login_pwd"
  end

  create_table "checks", force: true do |t|
    t.integer "member_id"
    t.string  "check_date"
    t.string  "check_result"
    t.text    "params"
    t.text    "intervention"
  end

  create_table "ks", force: true do |t|
    t.integer "school_id"
    t.string  "grade"
    t.string  "name"
  end

  create_table "masters", force: true do |t|
    t.integer "school_id"
    t.string  "login_name"
    t.string  "login_pwd"
  end

  create_table "members", force: true do |t|
    t.integer "school_id"
    t.integer "k_id"
    t.string  "name"
    t.string  "gender"
    t.string  "in_time"
    t.string  "mem_no"
    t.string  "login_name"
    t.string  "login_pwd"
  end

  create_table "schools", force: true do |t|
    t.string "name"
  end

end
