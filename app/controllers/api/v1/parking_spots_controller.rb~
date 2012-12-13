class Api::V1::ParkingSpotsController < ApplicationController
  # GET /parking_spots
  # GET /parking_spots.json
  
  #before_filter :authenticate_user!
  
  def index
    @parking_spots = RESOURCE_OFFER_HANDLER.retrieve_spots({:active=>true})
    presenter = Api::V1::ResourceOfferContainersPresenter.new

    toPresent = @parking_spots.map { |e| {:spots => e} }.as_json({:level_of_detail => params[:level_of_detail], :presenter => presenter})
    toPresent[:success] = "true"
    toPresent[:level_of_detail] =  params[:level_of_detail]
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: toPresent}
    end
  end

  # GET /parking_spots/1
  # GET /parking_spots/1.json
  def show
    #Fix id_numbering for (< v1.2)
    params[:id] = Integer(params[:id]) - 90000
    #end fix

    @parking_spot = RESOURCE_OFFER_HANDLER.retrieve_spots({:only=>[params[:id]]}).first
    presenter = Api::V1::ResourceOfferContainersPresenter.new
    
    spot_json = @parking_spot.as_json({:level_of_detail => params[:level_of_detail], :presenter => presenter})

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
