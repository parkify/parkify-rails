class MergeResourceOffer

  # for each resource, make a resource_offer. pass on any important info. Set each of the resource's 
  def updateResourceOffer()

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
      
      #CapacityInterval.joins(",capacity_lists,offers,resources").where("offers.resource_id = resources.id AND capacity_lists.offer_id = offers.id AND capacity_intervals.resource_offer_id = capacity_lists.id AND resources.id = ?", r.id).each do |ci|
      #   ciMutable = CapacityInterval.find_by_id(ci.id)
      #   ciMutable.resource_offer_id = ro.id
      #   ciMutable.save
      #end

      #PriceInterval.joins(",price_plans,offers,resources").where("offers.resource_id = resources.id AND price_plans.price_planable_id = offers.id AND price_plans.price_planable_type = ? AND price_intervals.resource_offer_id = price_plans.id AND resources.id = ?", "Offer", r.id).each do |pri|
      #   priMutable = PriceInterval.find_by_id(pri.id)
      #   priMutable.resource_offer_id = ro.id
      #   priMutable.save
      #end

      

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


  def updateAcceptances()
    Acceptance.all.each do |a|
     result = ActiveRecord::Base.connection.select_all("SELECT * FROM payment_infos where acceptance_id = #{a.id}").each do |pInfo| 
#PaymentInfo.joins(",acceptances").where("payment_infos.acceptance_id = acceptances.id AND acceptances.id = ?", a.id).each do |pInfo|
        a.card_id = pInfo["stripe_customer_id_id"]
        a.stripe_charge_id = pInfo["stripe_charge_id"]
        a.details = pInfo["details"]
        a.amount_charged = pInfo["amount_charged"]
      end         
      a.save
    end
  end
  
end
