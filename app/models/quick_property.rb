class QuickProperty < ActiveRecord::Base
  attr_accessible :key, :value, :resource_id
  belongs_to :resource
end
