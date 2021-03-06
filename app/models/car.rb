class Car < ActiveRecord::Base
  attr_accessible :details, :license_plate_number, :user_id, :active_car
  
  validates :license_plate_number, :length => { :minimum => 1 ,
  :too_short => "must have at least %{count} character" }
  
  belongs_to :user
  has_many :acceptances
  
  def as_json(options={})
    result = super(:only => [:id, :license_plate_number])
    result
  end
end
