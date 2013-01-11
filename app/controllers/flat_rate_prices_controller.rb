class FlatRatePricesController < ApplicationController
  # GET /flat_rate_prices
  # GET /flat_rate_prices.json
  def index
    @flat_rate_prices = FlatRatePrice.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @flat_rate_prices }
    end
  end

  # GET /flat_rate_prices/1
  # GET /flat_rate_prices/1.json
  def show
    @flat_rate_price = FlatRatePrice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @flat_rate_price }
    end
  end

  # GET /flat_rate_prices/new
  # GET /flat_rate_prices/new.json
  def new
    @flat_rate_price = FlatRatePrice.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @flat_rate_price }
    end
  end

  # GET /flat_rate_prices/1/edit
  def edit
    @flat_rate_price = FlatRatePrice.find(params[:id])
  end

  # POST /flat_rate_prices
  # POST /flat_rate_prices.json
  def create
    @flat_rate_price = FlatRatePrice.new(params[:flat_rate_price])

    respond_to do |format|
      if @flat_rate_price.save
        format.html { redirect_to @flat_rate_price, notice: 'Flat rate price was successfully created.' }
        format.json { render json: @flat_rate_price, status: :created, location: @flat_rate_price }
      else
        format.html { render action: "new" }
        format.json { render json: @flat_rate_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /flat_rate_prices/1
  # PUT /flat_rate_prices/1.json
  def update
    @flat_rate_price = FlatRatePrice.find(params[:id])

    respond_to do |format|
      if @flat_rate_price.update_attributes(params[:flat_rate_price])
        format.html { redirect_to @flat_rate_price, notice: 'Flat rate price was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @flat_rate_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flat_rate_prices/1
  # DELETE /flat_rate_prices/1.json
  def destroy
    @flat_rate_price = FlatRatePrice.find(params[:id])
    @flat_rate_price.destroy

    respond_to do |format|
      format.html { redirect_to flat_rate_prices_url }
      format.json { head :no_content }
    end
  end
end
