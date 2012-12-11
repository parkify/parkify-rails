class MergeResourceOffers < ActiveRecord::Migration
  
  

  def up
    create_table :resource_offers do |t|
      t.text :description,   :default => "",   :null => false
      t.integer :user_id
      t.string :title
      t.boolean :active,        :default => true
      t.integer :sign_id

      t.float    :latitude
      t.float    :longitude
      t.text     :location_name,     :default => "", :null => false
      t.text     :directions,        :default => "", :null => false
      t.text     :plain_directions,  :default => "", :null => false
      t.text     :location_address,  :default => "", :null => false

      t.timestamps
    end

    change_table :quick_properties do |t|
      t.rename :resource_id, :resource_offer_id
    end

    change_table :acceptances do |t|
      t.integer :resource_offer_id
    end

    updateResourceOffer
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end


  def updateResourceOffer()

    ResourceOffer.reset_column_information
    Location.reset_column_information
    Image.reset_column_information
    Acceptance.reset_column_information

    permanentSpots = [13,14,15,16,18,19,20,21,22,23,24,25,26,27,28,29,30] #spots that are up 24/7

    Resource.order(:id).each do |r|
      ro = ResourceOffer.create()
      ro.description = r.description
      ro.user_id = r.user_id
      ro.title = r.title
      ro.active = r.active
      ro.sign_id = r.id

      if(r.location)
        ro.latitude = r.location.latitude
        ro.longitude = r.location.longitude
        ro.location_name = r.location.location_name
        ro.directions = r.location.directions
        ro.plain_directions = r.location.plain_directions
          if(ro.plain_directions == nil)
            ro.plain_directions = "";
          end 
        ro.location_address = r.location.location_address
      end


      #okay, now fix all of the offer-related info.

      #rule of thumb, just grab each offer and push it's cap intervals and price intervals.
      #actually, now we're doing things with scedule generating info. So for now, just whitelist which spots should have 24/7 schedules.

      if(permanentSpots.include?(r.id))
        ro.offer_schedules.create({:recurrance_type=>"Day", :relative_start=>0, :duration=>60*60*24, :price_per_hour=>1, :capacity=>1})
      end

      Location.joins(",resources").where("locations.locationable_id = resources.id AND locations.locationable_type = ? AND resources.id = ?", "Resource", r.id).each do |loc|
        locMutable = Location.find_by_id(loc.id)
        locMutable.locationable_id = ro.id
        locMutable.locationable_type = "ResourceOffer"
        locMutable.save
      end

      Image.joins(",resources").where("images.imageable_id = resources.id AND images.imageable_type = ? AND resources.id = ?", "Resource", r.id).each do |img|
        imgMutable = Image.find_by_id(img.id)        
        imgMutable.imageable_id = ro.id
        imgMutable.imageable_type = "ResourceOffer"
        imgMutable.save
      end

      Acceptance.joins(",agreements,offers,resources").where("offers.resource_id = resources.id AND agreements.offer_id = offers.id AND agreements.acceptance_id = acceptances.id AND resources.id = ?", r.id).each do |a|
         aMutable = Acceptance.find_by_id(a)
         aMutable.resource_offer_id = ro.id
         aMutable.save
      end

      ro.save
    end

    #whew. let's hope that works...

  end



end
