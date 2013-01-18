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
  
  attr_accessor :copy_of
  attr_accessible :description, :name, :path, :image_attachment, :imageable, :copy_of
  
  after_save :update_handler

  # Deprecated
  def image_attachment_url
    if copy_of
      copy_of.url
    else
      image.url
    end
  end
  
  
  def landscape_for_spot_info_page
    return true
  end
  
  def landscape_for_spot_conf_page
    return true
  end
  
  def standard_for_instructions
    return true
  end
  
  def duplicate_and_attach_to(ids)
    ids.each do |resource_id|
      r = Resource.find_by_id(resource_id)
      b = self.dup
      b.image_attachment = self.image_attachment
      b.save
      r.images << b
      r.save
    end
  end


  def self.spot_images_are_viewable_test
    problem_images = Hash.new{|h,k| h[k] = []}

    Image.all.each do |img|
      ro = img.imageable
      if(img.imageable_type == "ResourceOffer" and !ro.nil?)
        #TODO: make general.
        url = "parkify-rails-staging.herokuapp.com/images/#{img.id}?image_attachment=true&style=original"
        size = FastImage.size(url)
        if size.nil? or size[0] == 0 or size[1] == 0
          problem_images[ro.id] << img.id
        end
      end
    end


    if problem_images.size == 0
      print "All spot images are viewable"
    else
      p "Problem with spot images: "
      p problem_images
    end
  end


  private
    def update_handler
      if self.imageable_type == "ResourceOffer"
        ApplicationController::update_resource_info([self.imageable_id])
      end
    end
end
