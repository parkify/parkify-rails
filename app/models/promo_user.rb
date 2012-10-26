class PromoUser < ActiveRecord::Base
  attr_accessible :code_id, :promo_idd, :user_id
  
  belongs_to :user, :promo, :code
  
end
