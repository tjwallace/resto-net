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

ActiveRecord::Schema.define(:version => 20101003062306) do

  create_table "establishments", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.integer  "owner_id"
    t.integer  "type_id"
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

  add_index "establishments", ["owner_id"], :name => "index_establishments_on_owner_id"
  add_index "establishments", ["type_id"], :name => "index_establishments_on_type_id"

  create_table "infraction_translations", :force => true do |t|
    t.integer  "infraction_id"
    t.string   "locale"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "infraction_translations", ["infraction_id"], :name => "index_infraction_translations_on_infraction_id"

  create_table "infractions", :force => true do |t|
    t.integer  "establishment_id"
    t.integer  "amount"
    t.date     "infraction_date"
    t.date     "judgment_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "owners", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "type_translations", :force => true do |t|
    t.integer  "type_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "type_translations", ["type_id"], :name => "index_type_translations_on_type_id"

  create_table "types", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end