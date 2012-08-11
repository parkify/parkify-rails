class OffersController < ApplicationController
  # GET /offers
  # GET /offers.json
  def index
    @resource = Resource.find(params[:resource_id])
    @offers = @resource.offers

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @offers }
    end
  end

  # GET /offers/1
  # GET /offers/1.json
  def show
    @resource = Resource.find(params[:resource_id])
    @offer = Offer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @offer }
    end
  end

  # GET /offers/new
  # GET /offers/new.json
  def new
    @resource = Resource.find(params[:resource_id])
    @offer = @resource.offers.new(params[:offer])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @offer }
    end
  end

  # GET /offers/1/edit
  def edit
    @resource = Resource.find(params[:resource_id])
    @offer = Offer.find(params[:id])
  end

  # POST /offers
  # POST /offers.json
  def create
    @resource = Resource.find(params[:resource_id])
    @offer = @resource.offers.new(params[:offer])

    respond_to do |format|
      if @offer.save
        @offer.updateWithParent!
        #@capacity_list = offer.capacity_list_build({:start_time=>params[:c
        format.html { redirect_to [@resource, @offer], notice: 'Offer was successfully created.' }
        format.json { render json: [@resource, @offer], status: :created, location: @offer }
      else
        format.html { render action: "new" }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /offers/1
  # PUT /offers/1.json
  def update
    @resource = Resource.find(params[:resource_id])
    @offer = Offer.find(params[:id])

    respond_to do |format|
      if @offer.update_attributes(params[:offer])
        @offer.updateWithParent!
        format.html { redirect_to @offer, notice: 'Offer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offers/1
  # DELETE /offers/1.json
  def destroy
    @resource = Resource.find(params[:resource_id])
    @offer = Offer.find(params[:id])
    @offer.destroy

    respond_to do |format|
      format.html { redirect_to offers_url }
      format.json { head :no_content }
    end
  end
end
