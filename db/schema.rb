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

ActiveRecord::Schema.define(:version => 20130110021625) do

  create_table "acceptances", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.float    "count",             :default => 0.0
    t.string   "status",            :default => "pre_pending"
    t.integer  "user_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.integer  "car_id"
    t.integer  "resource_offer_id"
    t.integer  "card_id"
    t.float    "amount_charged"
    t.string   "stripe_charge_id"
    t.string   "details",           :default => "",            :null => false
    t.string   "price_type",        :default => "",            :null => false
    t.string   "price_name",        :default => "",            :null => false
  end

  create_table "agreements", :force => true do |t|
    t.integer  "offer_id"
    t.integer  "acceptance_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "capacity_intervals", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.float    "capacity",         :default => 0.0
    t.integer  "capacity_list_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "capacity_lists", :force => true do |t|
    t.integer  "offer_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cards", :force => true do |t|
    t.string   "customer_id"
    t.integer  "user_id"
    t.boolean  "active_customer", :default => false, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.text     "last4",           :default => ""
  end

  create_table "cars", :force => true do |t|
    t.text     "details",              :default => "", :null => false
    t.string   "license_plate_number", :default => "", :null => false
    t.integer  "user_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "active_car",                           :null => false
  end

  create_table "codes", :force => true do |t|
    t.text     "code_text"
    t.boolean  "personal"
    t.integer  "promo_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "complaints", :force => true do |t|
    t.integer  "user_id"
    t.integer  "resource_offer_id"
    t.string   "description",       :default => "",    :null => false
    t.string   "imageurl",          :default => "",    :null => false
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "resolved",          :default => false, :null => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "device_users", :force => true do |t|
    t.integer  "device_id"
    t.integer  "user_id"
    t.datetime "last_used_at", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "devices", :force => true do |t|
    t.string   "device_uid",    :default => "", :null => false
    t.string   "push_token_id", :default => "", :null => false
    t.string   "device_type",   :default => "", :null => false
    t.datetime "last_used_at",                  :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "flat_rate_prices", :force => true do |t|
    t.float    "duration",   :default => 0.0, :null => false
    t.float    "price",      :default => 0.0, :null => false
    t.string   "name",       :default => "",  :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "images", :force => true do |t|
    t.string   "name",                          :default => "", :null => false
    t.string   "path",                          :default => "", :null => false
    t.string   "description",                   :default => "", :null => false
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.string   "image_attachment_file_name"
    t.string   "image_attachment_content_type"
    t.integer  "image_attachment_file_size"
    t.datetime "image_attachment_updated_at"
  end

  create_table "locations", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.text     "location_name",     :default => "", :null => false
    t.text     "directions",        :default => "", :null => false
    t.text     "location_address"
    t.integer  "locationable_id"
    t.string   "locationable_type"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.text     "plain_directions"
  end

  create_table "offer_schedule_exceptions", :force => true do |t|
    t.integer  "resource_offer_id"
    t.string   "exception_type",    :default => "modify", :null => false
    t.float    "start",             :default => 0.0,      :null => false
    t.float    "duration",          :default => 0.0,      :null => false
    t.float    "price",             :default => 1.0,      :null => false
    t.float    "capacity",          :default => 1.0,      :null => false
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "offer_schedule_flat_rate_prices", :force => true do |t|
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "offer_schedule_flat_rate_priceable_id"
    t.string   "offer_schedule_flat_rate_priceable_type"
    t.integer  "flat_rate_price_id"
  end

  create_table "offer_schedules", :force => true do |t|
    t.integer  "resource_offer_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "recurrance_type",   :default => "None", :null => false
    t.float    "relative_start",    :default => 0.0,    :null => false
    t.float    "duration",          :default => 0.0,    :null => false
    t.float    "price_per_hour",    :default => 1.0,    :null => false
    t.float    "capacity",          :default => 1.0,    :null => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  create_table "offers", :force => true do |t|
    t.float    "capacity",    :default => 0.0
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "resource_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "payment_infos", :force => true do |t|
    t.string   "stripe_customer_id_id"
    t.integer  "acceptance_id"
    t.float    "amount_charged"
    t.string   "stripe_charge_id"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "details",               :default => ""
  end

  create_table "price_intervals", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.float    "price_per_hour"
    t.integer  "price_plan_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "price_plans", :force => true do |t|
    t.float    "price_per_hour"
    t.integer  "price_planable_id"
    t.string   "price_planable_type"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "promo_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "promo_id"
    t.integer  "code_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "promos", :force => true do |t|
    t.text     "name"
    t.text     "description"
    t.text     "promo_type"
    t.datetime "start_time"
    t.datetime "end_time"
    t.float    "value1"
    t.float    "value2"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "quick_properties", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "resource_offer_id"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "resource_offers", :force => true do |t|
    t.text     "description",      :default => "",   :null => false
    t.integer  "user_id"
    t.string   "title"
    t.boolean  "active",           :default => true
    t.integer  "sign_id"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "location_name",    :default => "",   :null => false
    t.text     "directions",       :default => "",   :null => false
    t.text     "plain_directions", :default => "",   :null => false
    t.text     "location_address", :default => "",   :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "resources", :force => true do |t|
    t.text     "description",   :default => "",   :null => false
    t.integer  "location_id"
    t.float    "capacity",      :default => 0.0
    t.integer  "price_plan_id"
    t.integer  "user_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "title"
    t.boolean  "active",        :default => true
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",   :null => false
    t.string   "encrypted_password",     :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "authentication_token"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company_name"
    t.text     "billing_address"
    t.string   "company_phone_number"
    t.string   "zip_code"
    t.string   "phone_number"
    t.float    "credit",                 :default => 0.0
    t.boolean  "sms_notification",       :default => true, :null => false
    t.boolean  "email_notification",     :default => true, :null => false
    t.boolean  "push_notification",      :default => true, :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
