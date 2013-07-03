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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130703160005) do

  create_table "invoices", :force => true do |t|
    t.integer  "order_id"
    t.integer  "shop_id"
    t.string   "store_url"
    t.string   "order_number"
    t.string   "total"
    t.string   "email"
    t.string   "name"
    t.integer  "invoice_id"
    t.integer  "day"
    t.integer  "month"
    t.integer  "year"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "vat_number"
    t.integer  "client_id"
    t.boolean  "sent_email",   :default => false
  end

  create_table "shops", :force => true do |t|
    t.string   "name"
    t.string   "store_url"
    t.string   "email"
    t.string   "invoice_user"
    t.string   "invoice_api"
    t.boolean  "auto_send_email",     :default => true
    t.boolean  "auto_sequence",       :default => false
    t.string   "sequence_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "vat_code_default"
    t.string   "vat_code_inside_eu"
    t.string   "vat_code_outside_eu"
  end

end
