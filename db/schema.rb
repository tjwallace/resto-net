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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101120194456) do

  create_table "establishments", :force => true do |t|
    t.string   "name"
    t.string   "name_fingerprint"
    t.string   "address"
    t.string   "address_fingerprint"
    t.string   "city"
    t.string   "city_fingerprint"
    t.integer  "type_id"
    t.integer  "infractions_amount",  :default => 0
    t.integer  "infractions_count",   :default => 0
    t.integer  "judgment_span",       :default => 0
    t.float    "latitude"
    t.float    "longitude"
    t.string   "street"
    t.string   "region"
    t.string   "locality"
    t.string   "country"
    t.string   "postal_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "establishments", ["name_fingerprint", "address_fingerprint"], :name => "index_establishments_on_name_fingerprint_and_address_fingerprint", :unique => true
  add_index "establishments", ["type_id"], :name => "index_establishments_on_type_id"

  create_table "infractions", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "establishment_id"
    t.text     "description"
    t.integer  "amount"
    t.date     "infraction_date"
    t.date     "judgment_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "infractions", ["establishment_id"], :name => "index_infractions_on_establishment_id"
  add_index "infractions", ["owner_id"], :name => "index_infractions_on_owner_id"

  create_table "owners", :force => true do |t|
    t.string   "name"
    t.string   "name_fingerprint"
    t.integer  "infractions_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "owners", ["name_fingerprint"], :name => "index_owners_on_name_fingerprint", :unique => true

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "types", ["name"], :name => "index_types_on_name", :unique => true

end
