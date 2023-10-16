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

ActiveRecord::Schema[7.0].define(version: 2023_10_16_195836) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.string "city"
    t.string "postal_code", limit: 15
    t.bigint "patient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_addresses_on_patient_id"
  end

  create_table "caregivers", force: :cascade do |t|
    t.string "phone"
    t.bigint "health_center_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["health_center_id"], name: "index_caregivers_on_health_center_id"
  end

  create_table "devices", force: :cascade do |t|
    t.string "sim_sid"
    t.bigint "health_center_id", null: false
    t.bigint "patient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["health_center_id"], name: "index_devices_on_health_center_id"
    t.index ["patient_id"], name: "index_devices_on_patient_id"
  end

  create_table "health_centers", force: :cascade do |t|
    t.string "name"
    t.string "reference_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patients", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.text "additional_information"
    t.bigint "health_center_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["health_center_id"], name: "index_patients_on_health_center_id"
  end

  add_foreign_key "addresses", "patients"
  add_foreign_key "caregivers", "health_centers"
  add_foreign_key "devices", "health_centers"
  add_foreign_key "devices", "patients"
  add_foreign_key "patients", "health_centers"
end
