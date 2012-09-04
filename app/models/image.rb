class Image < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true
  has_attached_file :image_attachment, :style => {:spot_view_small => "118x96"},
    :url  => "/assets/image_attachments/:id/:style/:basename.:extension",
    :path => ":rails_root/public/assets/image_attachments/:id/:style/:basename.:extension",
    :storage => :s3,
    :s3_credentials => {
      :bucket            => ENV['S3_BUCKET_NAME'],
      :access_key_id     => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    }

  validates_attachment_size :image_attachment, :less_than => 5.megabytes
  validates_attachment_content_type :image_attachment, :content_type => ['image/jpeg', 'image/png']
  
  attr_accessible :description, :name, :path, :image_attachment, :imageable
  
  attr_accessor :copy_of
  
  def image_attachment_url
    if copy_of
      copy_of.url
    else
      image.url
    end
  end
end
