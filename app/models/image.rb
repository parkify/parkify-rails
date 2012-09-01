class Image < ActiveRecord::Base
  attr_accessible :description, :name, :path
  
  belongs_to :imageable, :polymorphic => true
  has_attached_file :attachment
end
