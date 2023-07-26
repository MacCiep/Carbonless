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

ActiveRecord::Schema.define(version: 2023_07_26_072420) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "achievements", force: :cascade do |t|
    t.string "title", null: false
    t.integer "scope_of_days"
    t.integer "points"
    t.integer "type"
    t.string "script", null: false
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "history_points", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "points", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "start_station"
    t.integer "end_station"
    t.integer "category"
    t.datetime "start_datetime"
    t.integer "history_type"
    t.integer "purchase_price"
    t.index ["user_id"], name: "index_history_points_on_user_id"
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "locations", force: :cascade do |t|
    t.bigint "machine_id", null: false
    t.decimal "latitude", null: false
    t.decimal "longitude", null: false
    t.string "country"
    t.string "city"
    t.index ["machine_id"], name: "index_locations_on_machine_id"
  end

  create_table "machines", force: :cascade do |t|
    t.string "secret", null: false
    t.integer "service_type", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "partner_id", null: false
    t.index ["partner_id"], name: "index_machines_on_partner_id"
  end

  create_table "partners", force: :cascade do |t|
    t.string "name"
    t.integer "points", default: 0, null: false
    t.text "description"
  end

  create_table "prizes", force: :cascade do |t|
    t.string "title", null: false
    t.integer "price", default: 0, null: false
    t.integer "duration", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "partner_id"
    t.index ["partner_id"], name: "index_prizes_on_partner_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.bigint "machine_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["machine_id"], name: "index_purchases_on_machine_id"
    t.index ["user_id"], name: "index_purchases_on_user_id"
  end

  create_table "travel_sessions", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "start_longitude"
    t.string "start_latitude"
    t.string "end_longitude"
    t.string "end_latitude"
    t.decimal "car_distance"
    t.boolean "active"
    t.bigint "machine_id"
    t.boolean "success", default: false
    t.integer "points", default: 0, null: false
    t.index ["user_id"], name: "index_travel_sessions_on_user_id"
  end

  create_table "user_achievements", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "achievement_id", null: false
    t.integer "counter", default: 0, null: false
    t.index ["achievement_id"], name: "index_user_achievements_on_achievement_id"
    t.index ["user_id"], name: "index_user_achievements_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "points", default: 0, null: false
    t.decimal "total_carbon_saved", default: "0.0"
    t.integer "tgtg_id"
    t.integer "theme", default: 0, null: false
    t.integer "language", default: 0, null: false
    t.integer "user_type", default: 0
    t.string "username"
    t.string "country"
    t.string "city"
    t.integer "score", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_prizes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "prize_id"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prize_id"], name: "index_users_prizes_on_prize_id"
    t.index ["user_id"], name: "index_users_prizes_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "prizes", "partners"
  add_foreign_key "purchases", "machines"
  add_foreign_key "purchases", "users"

  create_view "points_histories", sql_definition: <<-SQL
      SELECT points_history.partner_name,
      points_history.points,
      points_history.user_id,
      points_history.history_type,
      points_history.prize_title,
      points_history.created_at
     FROM ( SELECT purchases.user_id,
              purchases.created_at,
              partners.name AS partner_name,
              partners.points,
              NULL::text AS prize_title,
              'purchase'::text AS history_type
             FROM ((purchases
               JOIN machines ON ((purchases.machine_id = machines.id)))
               JOIN partners ON ((machines.partner_id = partners.id)))
          UNION
           SELECT travel_sessions.user_id,
              travel_sessions.updated_at AS created_at,
              partners.name AS partner_name,
              travel_sessions.points,
              NULL::text AS prize_title,
              'travel'::text AS history_type
             FROM ((travel_sessions
               JOIN machines ON ((travel_sessions.machine_id = machines.id)))
               JOIN partners ON ((machines.partner_id = partners.id)))
            WHERE (travel_sessions.success = true)
          UNION
           SELECT users_prizes.user_id,
              users_prizes.created_at,
              partners.name AS partner_name,
              prizes.price AS points,
              prizes.title AS prize_title,
              'prize'::text AS history_type
             FROM ((users_prizes
               JOIN prizes ON ((users_prizes.prize_id = prizes.id)))
               JOIN partners ON ((prizes.partner_id = partners.id)))) points_history
    ORDER BY points_history.created_at DESC;
  SQL
end
