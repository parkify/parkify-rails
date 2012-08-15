class Agreement < ActiveRecord::Base
  attr_accessible :acceptance_id, :offer_id
  
  belongs_to :acceptances,
  belongs_to :offers,
  
end
