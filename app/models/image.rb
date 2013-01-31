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
  attr_accessible :created_at, :description, :id, :image_attachment_content_type
  attr_accessible :image_attachment_file_name, :image_attachment_file_size
  attr_accessible :image_attachment_updated_at, :imageable_id, :imageable_type, :name, :path, :updated_at
  
  after_save :update_handler
  after_destroy :update_handler

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

        RestClient.get(url) do |response, request, result, &block|
          if response.code != 200
            problem_images[ro.id] << img.id
          end
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



  def update_handler
    if (self.imageable_type == "ResourceOffer")
      if (ResourceOffer.exists?(self.imageable_id))
        ResourceOfferContainer::update_spot(self.imageable_id, false)
      end
    end
  end

end
