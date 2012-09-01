class Image < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true
  has_attached_file :image_attachment
  
  attr_accessible :description, :name, :path, :image_attachment
end
