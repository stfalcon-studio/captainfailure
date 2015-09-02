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

ActiveRecord::Schema.define(version: 20150902075105) do

  create_table "availability_stats", force: :cascade do |t|
    t.integer  "check_id"
    t.float    "percent"
    t.string   "day_for"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "check_results", force: :cascade do |t|
    t.integer  "server_id"
    t.integer  "check_id"
    t.boolean  "passed"
    t.integer  "total_satellites"
    t.integer  "ready_satellites"
    t.string   "satellites_data"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "check_results", ["passed"], name: "index_check_results_on_passed"

  create_table "checks", force: :cascade do |t|
    t.integer  "server_id"
    t.integer  "check_type"
    t.integer  "check_via"
    t.integer  "tcp_port"
    t.integer  "http_code"
    t.string   "http_keyword"
    t.string   "http_vhost"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "icmp_count",     default: 5
    t.string   "http_uri"
    t.integer  "http_protocol",  default: 0
    t.boolean  "enabled",        default: true
    t.integer  "check_interval", default: 5
    t.integer  "fail_count",     default: 0
    t.integer  "timeout",        default: 30
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "notification_type"
    t.string   "value"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "notifications_schedules", force: :cascade do |t|
    t.integer  "notification_id"
    t.string   "m"
    t.string   "h"
    t.string   "dom"
    t.string   "mon"
    t.string   "dow"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "satellites", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "status",      default: false
  end

  create_table "satellites_servers", id: false, force: :cascade do |t|
    t.integer "satellite_id"
    t.integer "server_id"
  end

  create_table "server_notifications", force: :cascade do |t|
    t.integer  "server_id"
    t.integer  "notification_id"
    t.integer  "fail_to_notify_count", default: 1, null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "server_notifications", ["notification_id"], name: "index_server_notifications_on_notification_id"
  add_index "server_notifications", ["server_id"], name: "index_server_notifications_on_server_id"

  create_table "servers", force: :cascade do |t|
    t.string   "dns_name",               null: false
    t.string   "ip_address",             null: false
    t.string   "comment"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "alert_on",   default: 0
  end

  add_index "servers", ["dns_name"], name: "index_servers_on_dns_name"
  add_index "servers", ["ip_address"], name: "index_servers_on_ip_address"

  create_table "settings", force: :cascade do |t|
    t.string "name",  null: false
    t.string "value", null: false
  end

  add_index "settings", ["name"], name: "index_settings_on_name"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "is_admin",               default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
