require 'spec_helper'
require 'fastimage'

describe "Spot images" do
  describe "spot image visibility" do
    it "should be visible from browser" do

      #problem_spots = []
      #problem_images = []

      ResourceOffer.each do |ro|
        ro.images.each do |img|
          #TODO: make general.
          url = "parkify-rails-staging.herokuapp.com/images/#{img.id}?image_attachment=true&style=original"
          size = FastImage.size(url)
          size.should_not == nil
          size[0].should_not == 0
          size[1].should_not == 0
        end
      end

      #if problem_spots.size == 0
      #  print "All spot images are viewable"
      #else
      #  print "Problem with spot images:\n"
      #  p ["Problem Spots", problem_spots.map{|x| x.id}]
      #  p ["Problem Images", problem_images.map{|x| x.id}]
      #end
    end
  end
end
