

class ImageTestOld
  def self.spot_images_are_viewable_test
    problem_spots = []
    problem_images = []

    ResourceOffer.each do |ro|
      ro.images.each do |img|
        #TODO: make general.
        url = "parkify-rails-staging.herokuapp.com/images/#{img.id}?image_attachment=true&style=original"
        size = FastImage.size(url)
        if !size or size[0] == 0 or size[1] == 0
          problem_spots << ro
          problem_images << img
        end
      end
    end


    if problem_spots.size == 0
      print "All spot images are viewable"
    else
      print "Problem with spot images:\n"
      p ["Problem Spots", problem_spots.map{|x| x.id}]
      p ["Problem Images", problem_images.map{|x| x.id}]
    end
  end
end
