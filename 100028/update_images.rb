#!/usr/local/bin/ruby
require 'rake'
require 'rest_client'
require 'active_support'


production_server = ( ARGV.include?("--parkify-rails"))
SERVER_URL = "http://parkify-rails-staging.herokuapp.com"
if production_server
  SERVER_URL = "http://parkify-rails.herokuapp.com"
end


#find which sign_id to update
current_dir = FileUtils.pwd.split('/').last
sign_id = current_dir.to_i
if(!sign_id)
  exit
end


#find what images already exist for this spot
#TODO: make url for this specifically
response_resources = RestClient.get (SERVER_URL + '/resource_offers.json')
response_images = RestClient.get (SERVER_URL + '/images.json')
if(!response_resources || !response_images)
  exit
end
resources = ActiveSupport::JSON.decode(response_resources)
images = ActiveSupport::JSON.decode(response_images)



def image?(file_name)
  if ([".", ".."].include? file_name)
    return false
  elsif (!file_name.include? '.')
    return false
  elsif (["jpg","jpeg"].include? file_name.split('.').last) 
    return true
  else
    return false
  end
end

def get_name(file_name)
  return file_name.split('.')[0...-1].join(".")
end

def clean_images(resources,images)
  images.each do |img|
    if(img["imageable_type"] == "ResourceOffer" && resources.include?(img["imageable_id"]))
      p "Deleting image #{img["id"]}: #{img["imageable_id"]}/#{img["name"]}"
      begin
        RestClient.delete ("#{SERVER_URL}/images/#{img["id"]}")
      rescue => e
      end
    end
  end
end



def push_images(resources,images)
  image_names = Dir.new(File.dirname(__FILE__)).entries.reject {|f| !image?(f)}	
  image_names.each do |img_name|
    resources.each do |r|
      #check if there's already an image
      image_id = nil
      images.each do |img|
        if(img["imageable_type"] == "ResourceOffer" && r == img["imageable_id"] && img["name"] == get_name(img_name))
          image_id = img["id"]
          break
        end
      end

      p [r,img_name, get_name(img_name), image_id]
      if(! image_id.nil?)
        #update image with PUT
        p "Updating image #{image_id}: #{r}/#{get_name(img_name)}"
        begin
          RestClient.put "#{SERVER_URL}/images/#{img[image_id]}",:image => { :name=>get_name(img_name), :image_attachment => File.new(img_name, "rb")}
        rescue => e
        end
      else
        #create new image with POST
        p "Creating image: #{r}/#{get_name(img_name)}"
        begin
RestClient.post "#{SERVER_URL}/images.json", :image => {:name=>get_name(img_name), :image_attachment => File.new(img_name, "rb"), :imageable_type => "ResourceOffer", :imageable_id => r}
        rescue => e
        end
      end

    end
  end

end

resources = resources.reject {|x| x["sign_id"] != sign_id}.map {|x| x["id"] }


if(ARGV.include?("-c"))
  p "Removing all images for sign_id #{sign_id}"
  clean_images(resources,images)
elsif(ARGV.include?("-a"))
  push_images(resources,images)
end

p "Finished with #{sign_id}"

