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

ActiveRecord::Schema.define(version: 20151022105339) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "statutes", force: :cascade do |t|
    t.string   "state",                                     comment: "2 Character State Code or FEDERAL"
    t.date     "start_date",                                comment: "Date the schedule became The Law"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "blue_book_code"
    t.date     "expiration_date"
    t.datetime "deleted_at"
    t.string   "type"
    t.integer  "parent_id",                                 comment: "ID of the parent statute if this is an amendment"
    t.date     "duplicate_federal_as_of_date"
    t.text     "comment"
  end

  add_index "statutes", ["deleted_at", "start_date"], name: "index_statutes_on_deleted_at_and_start_date", using: :btree
  add_index "statutes", ["state", "start_date"], name: "index_statutes_on_state_and_start_date", unique: true, using: :btree

  create_table "substance_alternate_names", force: :cascade do |t|
    t.integer  "substance_id"
    t.string   "name"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "substance_statute_id"
    t.datetime "deleted_at"
  end

  add_index "substance_alternate_names", ["deleted_at"], name: "index_substance_alternate_names_on_deleted_at", using: :btree
  add_index "substance_alternate_names", ["substance_id"], name: "index_substance_alternate_names_on_substance_id", using: :btree
  add_index "substance_alternate_names", ["substance_statute_id"], name: "index_substance_alternate_names_on_substance_statute_id", using: :btree

  create_table "substance_classifications", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.datetime "deleted_at"
    t.boolean  "include_salts"
    t.boolean  "include_derivatives"
    t.boolean  "include_mixtures"
    t.boolean  "include_isomers"
    t.boolean  "include_optical_isomers"
    t.boolean  "include_geometric_isomers"
    t.boolean  "include_positional_isomers"
    t.boolean  "include_salts_of_isomers"
    t.boolean  "include_salts_of_optical_isomers"
    t.boolean  "include_esters"
    t.boolean  "include_ethers"
    t.boolean  "include_compounds"
    t.boolean  "include_materials"
    t.boolean  "include_preparations"
    t.text     "comment"
    t.integer  "statute_id"
    t.integer  "schedule_level"
  end

  add_index "substance_classifications", ["deleted_at"], name: "index_substance_classifications_on_deleted_at", using: :btree
  add_index "substance_classifications", ["name"], name: "index_substance_classifications_on_name", unique: true, using: :btree

  create_table "substance_statutes", force: :cascade do |t|
    t.integer  "substance_id"
    t.integer  "statute_id"
    t.integer  "schedule_level",                                comment: "1, 2, 3, 4, or 5"
    t.string   "penalty"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.datetime "deleted_at"
    t.boolean  "is_expiration"
    t.boolean  "include_salts"
    t.boolean  "include_derivatives"
    t.boolean  "include_mixtures"
    t.boolean  "include_isomers"
    t.boolean  "include_optical_isomers"
    t.boolean  "include_geometric_isomers"
    t.boolean  "include_positional_isomers"
    t.boolean  "include_salts_of_isomers"
    t.boolean  "include_salts_of_optical_isomers"
    t.boolean  "include_esters"
    t.boolean  "include_ethers"
    t.boolean  "include_compounds"
    t.boolean  "include_materials"
    t.boolean  "include_preparations"
    t.text     "comment"
    t.integer  "substance_classification_id"
  end

  add_index "substance_statutes", ["deleted_at", "is_expiration", "statute_id"], name: "idx_deleted_statute_expiration", using: :btree
  add_index "substance_statutes", ["deleted_at", "statute_id"], name: "index_substance_statutes_on_deleted_at_and_statute_id", using: :btree
  add_index "substance_statutes", ["deleted_at", "substance_classification_id"], name: "idx_deleted_at_classification", using: :btree
  add_index "substance_statutes", ["deleted_at", "substance_id", "statute_id", "schedule_level"], name: "idx_deleted_substance_schedule_level", unique: true, using: :btree

  create_table "substances", force: :cascade do |t|
    t.string   "name"
    t.string   "chemical_formula",                            comment: "In a readable format, e.g. N-ethyl-3-piperidyl benzilat"
    t.string   "chemical_formula_smiles_format",              comment: "Follows the SMILE standard: https://en.wikipedia.org/wiki/Simplified_molecular-input_line-entry_system"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "dea_code",                                    comment: "Administrative Controlled Substances Code Number. See https://en.wikipedia.org/wiki/Administrative_Controlled_Substances_Code_Number"
    t.datetime "deleted_at"
    t.string   "comment"
    t.string   "wikipedia_url"
  end

  add_index "substances", ["deleted_at"], name: "index_substances_on_deleted_at", using: :btree
  add_index "substances", ["name"], name: "index_substances_on_name", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "role"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
