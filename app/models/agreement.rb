class Agreement < ActiveRecord::Base
  attr_accessible :acceptance_id, :offer_id
  
  belongs_to :acceptance
  belongs_to :offer
  
end
