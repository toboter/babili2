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

ActiveRecord::Schema.define(version: 2018_11_15_164659) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "activities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "trackable_type"
    t.uuid "trackable_id"
    t.string "owner_type"
    t.uuid "owner_id"
    t.string "key"
    t.text "parameters"
    t.string "recipient_type"
    t.uuid "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_activities_on_owner_type_and_owner_id"
    t.index ["recipient_type", "recipient_id"], name: "index_activities_on_recipient_type_and_recipient_id"
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id"
  end

  create_table "friendly_id_slugs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "slug", null: false
    t.uuid "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "memberships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "organization_id"
    t.uuid "approver_id"
    t.datetime "approved_at"
    t.boolean "active", default: true, null: false
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_memberships_on_active"
    t.index ["approved_at"], name: "index_memberships_on_approved_at"
    t.index ["approver_id"], name: "index_memberships_on_approver_id"
    t.index ["organization_id"], name: "index_memberships_on_organization_id"
    t.index ["role"], name: "index_memberships_on_role"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "organizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_organizations_on_creator_id"
  end

  create_table "profiles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "owner_type"
    t.uuid "owner_id"
    t.string "slug"
    t.string "namespace"
    t.string "name"
    t.string "location"
    t.string "url"
    t.text "about"
    t.text "avatar_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "private", default: false, null: false
    t.index ["namespace"], name: "index_profiles_on_namespace", unique: true
    t.index ["owner_type", "owner_id"], name: "index_profiles_on_owner_type_and_owner_id"
    t.index ["private"], name: "index_profiles_on_private"
    t.index ["slug"], name: "index_profiles_on_slug", unique: true
  end

  create_table "user_sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.string "session_id"
    t.inet "ip"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_user_sessions_on_session_id", unique: true
    t.index ["user_id"], name: "index_user_sessions_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "approved_at"
    t.uuid "approver_id"
    t.boolean "admin", default: false, null: false
    t.jsonb "preferences"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin"], name: "index_users_on_admin"
    t.index ["approved_at"], name: "index_users_on_approved_at"
    t.index ["approver_id"], name: "index_users_on_approver_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vocabulary_concepts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "scheme_id"
    t.string "type"
    t.integer "references_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scheme_id"], name: "index_vocabulary_concepts_on_scheme_id"
    t.index ["type"], name: "index_vocabulary_concepts_on_type"
  end

  create_table "vocabulary_hyper_concepts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "uri"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vocabulary_labels", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "labelable_type"
    t.uuid "labelable_id"
    t.uuid "creator_id"
    t.string "type"
    t.string "vernacular"
    t.string "historical"
    t.string "body"
    t.string "language"
    t.boolean "abbrevation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_vocabulary_labels_on_creator_id"
    t.index ["labelable_type", "labelable_id"], name: "index_vocabulary_labels_on_labelable_type_and_labelable_id"
    t.index ["type"], name: "index_vocabulary_labels_on_type"
  end

  create_table "vocabulary_notes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "notable_type"
    t.uuid "notable_id"
    t.uuid "creator_id"
    t.string "type"
    t.text "body"
    t.string "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_vocabulary_notes_on_creator_id"
    t.index ["notable_type", "notable_id"], name: "index_vocabulary_notes_on_notable_type_and_notable_id"
    t.index ["type"], name: "index_vocabulary_notes_on_type"
  end

  create_table "vocabulary_relationships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "concept_id"
    t.uuid "creator_id"
    t.string "type"
    t.string "inversable_type"
    t.uuid "inversable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["concept_id"], name: "index_vocabulary_relationships_on_concept_id"
    t.index ["creator_id"], name: "index_vocabulary_relationships_on_creator_id"
    t.index ["inversable_type", "inversable_id"], name: "index_vocabulary_relationships_on_inverseable"
    t.index ["type"], name: "index_vocabulary_relationships_on_type"
  end

  create_table "vocabulary_schemes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "profile_id"
    t.uuid "creator_id"
    t.string "abbr"
    t.string "name"
    t.string "slug"
    t.integer "concepts_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["abbr"], name: "index_vocabulary_schemes_on_abbr"
    t.index ["creator_id"], name: "index_vocabulary_schemes_on_creator_id"
    t.index ["profile_id"], name: "index_vocabulary_schemes_on_profile_id"
    t.index ["slug"], name: "index_vocabulary_schemes_on_slug", unique: true
  end

  create_table "vocabulary_states", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "concept_id"
    t.uuid "creator_id"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["concept_id"], name: "index_vocabulary_states_on_concept_id"
    t.index ["creator_id"], name: "index_vocabulary_states_on_creator_id"
    t.index ["state"], name: "index_vocabulary_states_on_state"
  end

  add_foreign_key "memberships", "organizations"
  add_foreign_key "memberships", "users"
  add_foreign_key "memberships", "users", column: "approver_id"
  add_foreign_key "organizations", "users", column: "creator_id"
  add_foreign_key "user_sessions", "users"
  add_foreign_key "users", "users", column: "approver_id"
  add_foreign_key "vocabulary_concepts", "vocabulary_schemes", column: "scheme_id"
  add_foreign_key "vocabulary_labels", "users", column: "creator_id"
  add_foreign_key "vocabulary_notes", "users", column: "creator_id"
  add_foreign_key "vocabulary_relationships", "users", column: "creator_id"
  add_foreign_key "vocabulary_relationships", "vocabulary_concepts", column: "concept_id"
  add_foreign_key "vocabulary_schemes", "profiles"
  add_foreign_key "vocabulary_schemes", "users", column: "creator_id"
  add_foreign_key "vocabulary_states", "users", column: "creator_id"
  add_foreign_key "vocabulary_states", "vocabulary_concepts", column: "concept_id"
end
