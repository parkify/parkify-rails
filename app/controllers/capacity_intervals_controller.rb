class CapacityIntervalsController < ApplicationController
  # GET /capacity_intervals
  # GET /capacity_intervals.json
  def index
    @capacity_intervals = CapacityInterval.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @capacity_intervals }
    end
  end

  # GET /capacity_intervals/1
  # GET /capacity_intervals/1.json
  def show
    @capacity_interval = CapacityInterval.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @capacity_interval }
    end
  end

  # GET /capacity_intervals/new
  # GET /capacity_intervals/new.json
  def new
    @capacity_interval = CapacityInterval.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @capacity_interval }
    end
  end

  # GET /capacity_intervals/1/edit
  def edit
    @capacity_interval = CapacityInterval.find(params[:id])
  end

  # POST /capacity_intervals
  # POST /capacity_intervals.json
  def create
    @capacity_interval = CapacityInterval.new(params[:capacity_interval])

    respond_to do |format|
      if @capacity_interval.save
        format.html { redirect_to @capacity_interval, notice: 'Capacity interval was successfully created.' }
        format.json { render json: @capacity_interval, status: :created, location: @capacity_interval }
      else
        format.html { render action: "new" }
        format.json { render json: @capacity_interval.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /capacity_intervals/1
  # PUT /capacity_intervals/1.json
  def update
    @capacity_interval = CapacityInterval.find(params[:id])

    respond_to do |format|
      if @capacity_interval.update_attributes(params[:capacity_interval])
        format.html { redirect_to @capacity_interval, notice: 'Capacity interval was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @capacity_interval.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /capacity_intervals/1
  # DELETE /capacity_intervals/1.json
  def destroy
    @capacity_interval = CapacityInterval.find(params[:id])
    @capacity_interval.destroy

    respond_to do |format|
      format.html { redirect_to capacity_intervals_url }
      format.json { head :no_content }
    end
  end
end
