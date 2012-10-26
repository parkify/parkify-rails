class PromoUser < ActiveRecord::Base
  attr_accessible :code_id, :promo_id, :user_id
  
  belongs_to :user
  belongs_to :promo
  belongs_to :code
  
end
