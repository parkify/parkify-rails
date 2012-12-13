class Device < ActiveRecord::Base
  attr_accessible :device_type, :device_uid, :last_used_at, :push_token_id, :device_users, :users

  has_many :device_users
  has_many :users, :through => :device_users

end