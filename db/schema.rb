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

ActiveRecord::Schema.define(:version => 20121124080348) do

  create_table "account_transactions", :force => true do |t|
    t.integer  "from_account_id"
    t.integer  "to_account_id"
    t.decimal  "due_amount",                :precision => 10, :scale => 0, :default => 0
    t.decimal  "principle_credit_amount",   :precision => 10, :scale => 0, :default => 0
    t.decimal  "principle_interest_amount", :precision => 10, :scale => 0, :default => 0
    t.decimal  "principle_debit_amount",    :precision => 10, :scale => 0, :default => 0
    t.datetime "created_at",                                                              :null => false
    t.datetime "updated_at",                                                              :null => false
  end

  create_table "accounts", :force => true do |t|
    t.string   "accountable_type"
    t.integer  "accountable_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "group_admins", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "name",                                            :null => false
    t.text     "description"
    t.integer  "group_admin_id"
    t.decimal  "total_amount",     :precision => 10, :scale => 0
    t.integer  "principal_amount"
    t.integer  "interest_amount"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username",                                                                 :null => false
    t.string   "fullname"
    t.string   "last_name"
    t.string   "first_name"
    t.boolean  "is_locked",                                              :default => true
    t.string   "door_no"
    t.string   "street"
    t.string   "state"
    t.integer  "pincode"
    t.text     "description"
    t.string   "primary_phone"
    t.string   "secondary_phone"
    t.string   "tertiary_phone"
    t.string   "email_id"
    t.integer  "role_id"
    t.decimal  "total_credit",            :precision => 10, :scale => 0, :default => 0,    :null => false
    t.decimal  "credit_without_interest", :precision => 10, :scale => 0, :default => 0,    :null => false
    t.decimal  "interest_for_credit",     :precision => 10, :scale => 0, :default => 0,    :null => false
    t.decimal  "total_debit",             :precision => 10, :scale => 0, :default => 0,    :null => false
    t.decimal  "debit_without_interest",  :precision => 10, :scale => 0, :default => 0,    :null => false
    t.decimal  "interest_for_debit",      :precision => 10, :scale => 0, :default => 0,    :null => false
    t.integer  "group_id"
    t.datetime "created_at",                                                               :null => false
    t.datetime "updated_at",                                                               :null => false
  end

end
