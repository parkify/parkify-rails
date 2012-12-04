class ResourceOffersController < ApplicationController
  # GET /resource_offers
  # GET /resource_offers.json
  def index
    @resource_offers = ResourceOffer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @resource_offers }
    end
  end

  # GET /resource_offers/1
  # GET /resource_offers/1.json
  def show
    @resource_offer = ResourceOffer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @resource_offer }
    end
  end

  # GET /resource_offers/new
  # GET /resource_offers/new.json
  def new
    @resource_offer = ResourceOffer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @resource_offer }
    end
  end

  # GET /resource_offers/1/edit
  def edit
    @resource_offer = ResourceOffer.find(params[:id])
  end

  # POST /resource_offers
  # POST /resource_offers.json
  def create
    @resource_offer = ResourceOffer.new(params[:resource_offer])

    respond_to do |format|
      if @resource_offer.save
        format.html { redirect_to @resource_offer, notice: 'Resource offer was successfully created.' }
        format.json { render json: @resource_offer, status: :created, location: @resource_offer }
      else
        format.html { render action: "new" }
        format.json { render json: @resource_offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /resource_offers/1
  # PUT /resource_offers/1.json
  def update
    @resource_offer = ResourceOffer.find(params[:id])

    respond_to do |format|
      if @resource_offer.update_attributes(params[:resource_offer])
        format.html { redirect_to @resource_offer, notice: 'Resource offer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @resource_offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resource_offers/1
  # DELETE /resource_offers/1.json
  def destroy
    @resource_offer = ResourceOffer.find(params[:id])
    @resource_offer.destroy

    respond_to do |format|
      format.html { redirect_to resource_offers_url }
      format.json { head :no_content }
    end
  end
end
