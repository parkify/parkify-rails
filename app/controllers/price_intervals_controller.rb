class PriceIntervalsController < ApplicationController
  # GET /price_intervals
  # GET /price_intervals.json
  def index
    @price_intervals = PriceInterval.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @price_intervals }
    end
  end

  # GET /price_intervals/1
  # GET /price_intervals/1.json
  def show
    @price_interval = PriceInterval.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @price_interval }
    end
  end

  # GET /price_intervals/new
  # GET /price_intervals/new.json
  def new
    @price_interval = PriceInterval.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @price_interval }
    end
  end

  # GET /price_intervals/1/edit
  def edit
    @price_interval = PriceInterval.find(params[:id])
  end

  # POST /price_intervals
  # POST /price_intervals.json
  def create
    @price_interval = PriceInterval.new(params[:price_interval])

    respond_to do |format|
      if @price_interval.save
        format.html { redirect_to @price_interval, notice: 'Price interval was successfully created.' }
        format.json { render json: @price_interval, status: :created, location: @price_interval }
      else
        format.html { render action: "new" }
        format.json { render json: @price_interval.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /price_intervals/1
  # PUT /price_intervals/1.json
  def update
    @price_interval = PriceInterval.find(params[:id])

    respond_to do |format|
      if @price_interval.update_attributes(params[:price_interval])
        format.html { redirect_to @price_interval, notice: 'Price interval was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @price_interval.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /price_intervals/1
  # DELETE /price_intervals/1.json
  def destroy
    @price_interval = PriceInterval.find(params[:id])
    @price_interval.destroy

    respond_to do |format|
      format.html { redirect_to price_intervals_url }
      format.json { head :no_content }
    end
  end
end
