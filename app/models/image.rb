class Image < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true
  :has_attached_file :image_attachment, :style => {:spot_view_small => "118x96"},
    :url  => "/assets/image_attachments/:id/:style/:basename.:extension",
    :path => ":rails_root/public/assets/image_attachments/:id/:style/:basename.:extension"

  validates_attachment_size :image_attatchment, :less_than => 5.megabytes
  validates_attachment_content_type :image_attachment, :content_type => ['image/jpeg', 'image/png']
  
  attr_accessible :description, :name, :path, :image_attachment, :imageable
end
