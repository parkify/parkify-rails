class Device < ActiveRecord::Base
  attr_accessible :device_type, :device_uid, :last_used_at, :push_token_id, :device_users, :users

  has_many :device_users
  has_many :users, :through => :device_users

  def has_trial_account
    return false

    #if(self.users.count != 1)
    #  return false
    #end
    #user = self.users.first
    #return (user.nil?) ? false : (user.trial?)
  end

  def trial_account
    return = self.users.where("account_type = ?", "trial").first
  end
  

end
