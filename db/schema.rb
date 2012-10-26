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

ActiveRecord::Schema.define(:version => 20121026145137) do

  create_table "acceptances", :force => true do |t|
    t.timestamp "start_time"
    t.timestamp "end_time"
    t.float     "count",      :default => 0.0
    t.string    "status",     :default => "pre_pending"
    t.integer   "user_id"
    t.timestamp "created_at",                            :null => false
    t.timestamp "updated_at",                            :null => false
    t.integer   "car_id"
  end

  create_table "agreements", :force => true do |t|
    t.integer   "offer_id"
    t.integer   "acceptance_id"
    t.timestamp "created_at",    :null => false
    t.timestamp "updated_at",    :null => false
  end

  create_table "capacity_intervals", :force => true do |t|
    t.timestamp "start_time"
    t.timestamp "end_time"
    t.float     "capacity",         :default => 0.0
    t.integer   "capacity_list_id"
    t.timestamp "created_at",                        :null => false
    t.timestamp "updated_at",                        :null => false
  end

  create_table "capacity_lists", :force => true do |t|
    t.integer   "offer_id"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  create_table "cars", :force => true do |t|
    t.text      "details",              :default => "", :null => false
    t.string    "license_plate_number", :default => "", :null => false
    t.integer   "user_id"
    t.timestamp "created_at",                           :null => false
    t.timestamp "updated_at",                           :null => false
    t.boolean   "active_car",                           :null => false
  end

  create_table "codes", :force => true do |t|
    t.text     "code_text"
    t.boolean  "personal"
    t.integer  "promo_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "images", :force => true do |t|
    t.string    "name",                          :default => "", :null => false
    t.string    "path",                          :default => "", :null => false
    t.string    "description",                   :default => "", :null => false
    t.integer   "imageable_id"
    t.string    "imageable_type"
    t.timestamp "created_at",                                    :null => false
    t.timestamp "updated_at",                                    :null => false
    t.string    "image_attachment_file_name"
    t.string    "image_attachment_content_type"
    t.integer   "image_attachment_file_size"
    t.timestamp "image_attachment_updated_at"
  end

  create_table "locations", :force => true do |t|
    t.float     "latitude"
    t.float     "longitude"
    t.text      "location_name",     :default => "", :null => false
    t.text      "directions",        :default => "", :null => false
    t.text      "location_address"
    t.integer   "locationable_id"
    t.string    "locationable_type"
    t.timestamp "created_at",                        :null => false
    t.timestamp "updated_at",                        :null => false
  end

  create_table "offers", :force => true do |t|
    t.float     "capacity",    :default => 0.0
    t.timestamp "start_time"
    t.timestamp "end_time"
    t.integer   "resource_id"
    t.timestamp "created_at",                   :null => false
    t.timestamp "updated_at",                   :null => false
  end

  create_table "payment_infos", :force => true do |t|
    t.string    "stripe_customer_id_id"
    t.integer   "acceptance_id"
    t.float     "amount_charged"
    t.string    "stripe_charge_id"
    t.timestamp "created_at",                            :null => false
    t.timestamp "updated_at",                            :null => false
    t.string    "details",               :default => ""
  end

  create_table "price_intervals", :force => true do |t|
    t.timestamp "start_time"
    t.timestamp "end_time"
    t.float     "price_per_hour"
    t.integer   "price_plan_id"
    t.timestamp "created_at",     :null => false
    t.timestamp "updated_at",     :null => false
  end

  create_table "price_plans", :force => true do |t|
    t.float     "price_per_hour"
    t.integer   "price_planable_id"
    t.string    "price_planable_type"
    t.timestamp "created_at",          :null => false
    t.timestamp "updated_at",          :null => false
  end

  create_table "promo_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "promo_idd"
    t.integer  "code_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "promos", :force => true do |t|
    t.text     "name"
    t.text     "description"
    t.text     "type"
    t.datetime "start_time"
    t.datetime "end_time"
    t.float    "value1"
    t.float    "value2"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "quick_properties", :force => true do |t|
    t.string    "key"
    t.string    "value"
    t.timestamp "created_at",  :null => false
    t.timestamp "updated_at",  :null => false
    t.integer   "resource_id"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text      "message"
    t.string    "username"
    t.integer   "item"
    t.string    "table"
    t.integer   "month"
    t.integer   "year"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "resources", :force => true do |t|
    t.text      "description",   :default => "",   :null => false
    t.integer   "location_id"
    t.float     "capacity",      :default => 0.0
    t.integer   "price_plan_id"
    t.integer   "user_id"
    t.timestamp "created_at",                      :null => false
    t.timestamp "updated_at",                      :null => false
    t.string    "title"
    t.boolean   "active",        :default => true
  end

  create_table "stripe_customer_ids", :force => true do |t|
    t.string    "customer_id"
    t.integer   "user_id"
    t.boolean   "active_customer", :default => false, :null => false
    t.timestamp "created_at",                         :null => false
    t.timestamp "updated_at",                         :null => false
    t.text      "last4",           :default => ""
  end

  create_table "users", :force => true do |t|
    t.string    "email",                  :default => "",  :null => false
    t.string    "encrypted_password",     :default => "",  :null => false
    t.string    "reset_password_token"
    t.timestamp "reset_password_sent_at"
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",          :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.timestamp "created_at",                              :null => false
    t.timestamp "updated_at",                              :null => false
    t.string    "authentication_token"
    t.string    "first_name"
    t.string    "last_name"
    t.string    "company_name"
    t.text      "billing_address"
    t.string    "company_phone_number"
    t.string    "zip_code"
    t.string    "phone_number"
    t.float     "credit",                 :default => 0.0
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
