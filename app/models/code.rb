class Code < ActiveRecord::Base
  attr_accessible :code_text, :personal, :promo_id
  
  belongs_to :promo
  has_many :promo_users
  has_many :users, :through => :promo_users
  
end
