# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_11_21_214640) do
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "completions", force: :cascade do |t|
    t.integer "habit_id", null: false
    t.integer "user_id", null: false
    t.date "completed_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["habit_id"], name: "index_completions_on_habit_id"
    t.index ["user_id"], name: "index_completions_on_user_id"
  end

  create_table "exercise_completions", force: :cascade do |t|
    t.integer "exercise_id", null: false
    t.integer "user_id", null: false
    t.date "completed_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id", "completed_on"], name: "index_exercise_completions_on_exercise_id_and_completed_on", unique: true
    t.index ["exercise_id"], name: "index_exercise_completions_on_exercise_id"
    t.index ["user_id"], name: "index_exercise_completions_on_user_id"
  end

  create_table "exercises", force: :cascade do |t|
    t.integer "workout_id", null: false
    t.string "name", null: false
    t.string "details"
    t.integer "xp_reward", default: 5, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workout_id"], name: "index_exercises_on_workout_id"
  end

  create_table "habits", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.string "category"
    t.integer "xp_reward", default: 10, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "mandatory", default: false, null: false
    t.index ["user_id"], name: "index_habits_on_user_id"
  end

  create_table "journal_entries", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "entry_date", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "entry_date"], name: "index_journal_entries_on_user_id_and_entry_date", unique: true
    t.index ["user_id"], name: "index_journal_entries_on_user_id"
  end

  create_table "penalties", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "habit_id", null: false
    t.string "habit_name", null: false
    t.date "penalty_date", null: false
    t.integer "xp_lost", default: 0, null: false
    t.integer "coins_lost", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "habit_id", "penalty_date"], name: "index_penalties_on_user_id_and_habit_id_and_penalty_date", unique: true
    t.index ["user_id"], name: "index_penalties_on_user_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "reward_name", null: false
    t.integer "cost", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_purchases_on_user_id"
  end

  create_table "rewards", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.integer "cost", default: 20, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_rewards_on_user_id"
  end

  create_table "schedule_items", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "start_time", null: false
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "start_time"], name: "index_schedule_items_on_user_id_and_start_time"
    t.index ["user_id"], name: "index_schedule_items_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "level", default: 1, null: false
    t.integer "xp", default: 0, null: false
    t.string "rank", default: "E", null: false
    t.integer "strength", default: 0, null: false
    t.integer "intelligence", default: 0, null: false
    t.integer "vitality", default: 0, null: false
    t.integer "discipline", default: 0, null: false
    t.integer "coins", default: 0, null: false
    t.integer "attribute_points", default: 0, null: false
    t.date "last_penalty_check"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workouts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_workouts_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "completions", "habits"
  add_foreign_key "completions", "users"
  add_foreign_key "exercise_completions", "exercises"
  add_foreign_key "exercise_completions", "users"
  add_foreign_key "exercises", "workouts"
  add_foreign_key "habits", "users"
  add_foreign_key "journal_entries", "users"
  add_foreign_key "penalties", "users"
  add_foreign_key "purchases", "users"
  add_foreign_key "rewards", "users"
  add_foreign_key "schedule_items", "users"
  add_foreign_key "workouts", "users"
end
