class Complaint < ActiveRecord::Base
  attr_accessible :description, :latitude, :longitude, :resolved, :resource_offer_id, :user_id

  belongs_to :user
  belongs_to :resource_offer

  has_many :images, :as => :imageable

end
