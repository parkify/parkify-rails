class Location < ActiveRecord::Base
  attr_accessible :directions, :plain_directions, :latitude, :location_address, :location_name, :longitude
  belongs_to :locationable, :polymorphic => true
  
  def as_json(options={})
    result = super(:only => [:latitude, :longitude, :location_name])
    
    if(options[:level_of_detail] == "all")
      result["directions"] = self.directions
      result["location_address"] = self.location_address
    end
    
    result
  end

# Interprets text_in as simple directions and transforms into
# xml directions (interpreting newlines as direction separators)
# Then, sets current direction as this xml direction string
# and simple_directions as the original string.
  def read_in_plain_directions (text_in)
    self.plain_directions = text_in
    xml_in = text_in.gsub "\n", "</Text></Direction><Direction><Text>"
    xml_in.insert 0, "<Directions><Direction><Text>"
    xml_in.insert -1, "</Text></Direction></Directions>"
    self.directions = xml_in
    self
  end
end
