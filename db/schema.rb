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

ActiveRecord::Schema.define(:version => 20121205181324) do

  create_table "account_tran_details", :force => true do |t|
    t.integer  "from_account_id",                                                 :null => false
    t.integer  "to_account_id",                                                   :null => false
    t.date     "transaction_date"
    t.decimal  "saving",            :precision => 10, :scale => 0, :default => 0
    t.decimal  "due",               :precision => 10, :scale => 0, :default => 0
    t.decimal  "principle_debit",   :precision => 10, :scale => 0, :default => 0
    t.decimal  "principle_credit",  :precision => 10, :scale => 0, :default => 0
    t.decimal  "interest_credit",   :precision => 10, :scale => 0, :default => 0
    t.decimal  "other_amount",      :precision => 10, :scale => 0, :default => 0
    t.decimal  "from_outs_balance", :precision => 10, :scale => 0, :default => 0
    t.decimal  "to_outs_balance",   :precision => 10, :scale => 0, :default => 0
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
  end

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.integer  "accountable_id"
    t.string   "accountable_type"
    t.decimal  "outstanding_balance", :precision => 10, :scale => 0, :default => 0
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
  end

  create_table "banks", :force => true do |t|
    t.string   "bank_name"
    t.string   "branch"
    t.string   "account_name"
    t.string   "account_number"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "groups_users", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.boolean  "is_admin",   :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name",                             :null => false
    t.string   "last_name",                              :null => false
    t.date     "dob"
    t.boolean  "is_locked"
    t.string   "door_no"
    t.string   "street"
    t.string   "state"
    t.integer  "pincode"
    t.text     "description"
    t.string   "primary_phone"
    t.string   "secondary_phone"
    t.string   "tertiary_phone"
    t.integer  "role_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
