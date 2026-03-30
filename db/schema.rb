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

ActiveRecord::Schema[7.1].define(version: 2026_03_30_175603) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chats", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_chats_on_user_id"
  end

  create_table "families", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "meal_plans", force: :cascade do |t|
    t.date "day"
    t.bigint "family_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["family_id"], name: "index_meal_plans_on_family_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.string "role"
    t.bigint "chat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
  end

  create_table "recipe_meal_plans", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "meal_plan_id", null: false
    t.string "meal_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meal_plan_id"], name: "index_recipe_meal_plans_on_meal_plan_id"
    t.index ["recipe_id"], name: "index_recipe_meal_plans_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "name"
    t.text "ingredients"
    t.text "description"
    t.string "keywords"
    t.integer "calories"
    t.string "allergens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rewards", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "reward_points"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_rewards_on_user_id"
  end

  create_table "task_templates", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "task_points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "family_member_id", null: false
    t.boolean "status"
    t.date "start_date"
    t.date "end_date"
    t.integer "task_points"
    t.integer "frequency"
    t.bigint "task_template_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["family_member_id"], name: "index_tasks_on_family_member_id"
    t.index ["task_template_id"], name: "index_tasks_on_task_template_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "chats", "users"
  add_foreign_key "meal_plans", "families"
  add_foreign_key "messages", "chats"
  add_foreign_key "recipe_meal_plans", "meal_plans"
  add_foreign_key "recipe_meal_plans", "recipes"
  add_foreign_key "rewards", "users"
  add_foreign_key "tasks", "task_templates"
  add_foreign_key "tasks", "users", column: "family_member_id"
end
