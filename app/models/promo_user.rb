class PromoUser < ActiveRecord::Base
  attr_accessible :code_id, :promo_id, :user_id
  
  belongs_to :user
  belongs_to :promo
  belongs_to :code
  
  def as_json(options={})
    result = super(:only => [:id])
    result[:id] = promo_id
    result[:name] = self.promo.name
    result[:description] = self.promo.description
    result[:code_text] = self.code.code_text
    p "checking as json of promouser..."
    p result
    p "...end"
    result
  end
  
end
