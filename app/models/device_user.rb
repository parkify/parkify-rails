class DeviceUser < ActiveRecord::Base
  attr_accessible :device_id, :last_used_at, :user_id, :user, :device

  belongs_to :user
  belongs_to :device

end

