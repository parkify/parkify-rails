class Image < ActiveRecord::Base
  attr_accessible :description, :name, :path
  
  belongs_to :imageable, :polymorphic => true
  
end
