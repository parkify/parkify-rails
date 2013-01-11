class OfferScheduleFlatRatePricesController < ApplicationController
  # GET /offer_schedule_flat_rate_prices
  # GET /offer_schedule_flat_rate_prices.json
  def index
    @offer_schedule_flat_rate_prices = OfferScheduleFlatRatePrice.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @offer_schedule_flat_rate_prices }
    end
  end

  # GET /offer_schedule_flat_rate_prices/1
  # GET /offer_schedule_flat_rate_prices/1.json
  def show
    @offer_schedule_flat_rate_price = OfferScheduleFlatRatePrice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @offer_schedule_flat_rate_price }
    end
  end

  # GET /offer_schedule_flat_rate_prices/new
  # GET /offer_schedule_flat_rate_prices/new.json
  def new
    @offer_schedule_flat_rate_price = OfferScheduleFlatRatePrice.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @offer_schedule_flat_rate_price }
    end
  end

  # GET /offer_schedule_flat_rate_prices/1/edit
  def edit
    @offer_schedule_flat_rate_price = OfferScheduleFlatRatePrice.find(params[:id])
  end

  # POST /offer_schedule_flat_rate_prices
  # POST /offer_schedule_flat_rate_prices.json
  def create
    @offer_schedule_flat_rate_price = OfferScheduleFlatRatePrice.new(params[:offer_schedule_flat_rate_price])

    respond_to do |format|
      if @offer_schedule_flat_rate_price.save
        format.html { redirect_to @offer_schedule_flat_rate_price, notice: 'Offer schedule flat rate price was successfully created.' }
        format.json { render json: @offer_schedule_flat_rate_price, status: :created, location: @offer_schedule_flat_rate_price }
      else
        format.html { render action: "new" }
        format.json { render json: @offer_schedule_flat_rate_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /offer_schedule_flat_rate_prices/1
  # PUT /offer_schedule_flat_rate_prices/1.json
  def update
    @offer_schedule_flat_rate_price = OfferScheduleFlatRatePrice.find(params[:id])

    respond_to do |format|
      if @offer_schedule_flat_rate_price.update_attributes(params[:offer_schedule_flat_rate_price])
        format.html { redirect_to @offer_schedule_flat_rate_price, notice: 'Offer schedule flat rate price was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @offer_schedule_flat_rate_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offer_schedule_flat_rate_prices/1
  # DELETE /offer_schedule_flat_rate_prices/1.json
  def destroy
    @offer_schedule_flat_rate_price = OfferScheduleFlatRatePrice.find(params[:id])
    @offer_schedule_flat_rate_price.destroy

    respond_to do |format|
      format.html { redirect_to offer_schedule_flat_rate_prices_url }
      format.json { head :no_content }
    end
  end
end
