class Api::V2::ParkingSpotsController < ApplicationController
  # GET /parking_spots
  # GET /parking_spots.json
  
  #before_filter :authenticate_user!

  def debug_check_1 (s1)
    s1.each do |k,v|
      if(v[:id] == nil)
        p ["Empty resource offer container:", k, v]
        p ["original:", @parking_spots[k]]
      end
    end
  end
  
  def index
    handler = ResourceOfferHandler.new
    @parking_spots = handler.retrieve_spots({:active=>true})
    presenter = Api::V2::ResourceOfferContainersPresenter.new

    spotsAsHash = {}

    @parking_spots.each {|k,v| spotsAsHash[k] = presenter.as_json(v, {:level_of_detail => params[:level_of_detail]})}

    #debug_check_1(spotsAsHash)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {:spots => spotsAsHash, :success => true, :level_of_detail => params[:level_of_detail]}}
    end
  end

  # GET /parking_spots/1
  # GET /parking_spots/1.json
  def show
    #Fix id_numbering for (< v1.2)
    params[:id] = Integer(params[:id]) + 10000
    #ro = ResourceOffer.find_by_sign_id(params[:id])
    ro = ResourceOffer.find(Integer(params[:id]))
    #end fix

    handler = ResourceOfferHandler.new
    @parking_spot = handler.retrieve_spots({:only=>[ro.id]}).first
    if !@parking_spot
      p ["this spot is nil.", RESOUCE_OFFER_HANDLER]
    end



    presenter = Api::V2::ResourceOfferContainersPresenter.new
    
    spot_json = presenter.as_json(@parking_spot, {:level_of_detail => params[:level_of_detail]})

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {:success => "true", :spot => spot_json, :count => "one", :level_of_detail => params[:level_of_detail]} }
    end
  end

  
  
  #TODO: SUPPORT BELOW
  
  # GET /parking_spots/new
  # GET /parking_spots/new.json
  def new
    @parking_spot = ParkingSpot.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @parking_spot }
    end
  end

  # GET /parking_spots/1/edit
  def edit
    @parking_spot = ParkingSpot.find(params[:id])
  end

  # POST /parking_spots
  # POST /parking_spots.json
  def create
    @parking_spot = ParkingSpot.new(params[:parking_spot])

    respond_to do |format|
      if @parking_spot.save
        format.html { redirect_to @parking_spot, notice: 'Parking spot was successfully created.' }
        format.json { render json: @parking_spot, status: :created, location: @parking_spot }
      else
        format.html { render action: "new" }
        format.json { render json: @parking_spot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /parking_spots/1
  # PUT /parking_spots/1.json
  def update
    @parking_spot = ParkingSpot.find(params[:id])

    respond_to do |format|
      if @parking_spot.update_attributes(params[:parking_spot])
        format.html { redirect_to @parking_spot, notice: 'Parking spot was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @parking_spot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parking_spots/1
  # DELETE /parking_spots/1.json
  def destroy
    @parking_spot = ParkingSpot.find(params[:id])
    @parking_spot.destroy

    respond_to do |format|
      format.html { redirect_to parking_spots_url }
      format.json { head :no_content }
    end
  end
end
