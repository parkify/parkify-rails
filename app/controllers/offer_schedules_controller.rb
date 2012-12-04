class OfferSchedulesController < ApplicationController
  # GET /offer_schedules
  # GET /offer_schedules.json
  def index
    @offer_schedules = OfferSchedule.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @offer_schedules }
    end
  end

  # GET /offer_schedules/1
  # GET /offer_schedules/1.json
  def show
    @offer_schedule = OfferSchedule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @offer_schedule }
    end
  end

  # GET /offer_schedules/new
  # GET /offer_schedules/new.json
  def new
    @offer_schedule = OfferSchedule.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @offer_schedule }
    end
  end

  # GET /offer_schedules/1/edit
  def edit
    @offer_schedule = OfferSchedule.find(params[:id])
  end

  # POST /offer_schedules
  # POST /offer_schedules.json
  def create
    @offer_schedule = OfferSchedule.new(params[:offer_schedule])

    respond_to do |format|
      if @offer_schedule.save
        format.html { redirect_to @offer_schedule, notice: 'Offer schedule was successfully created.' }
        format.json { render json: @offer_schedule, status: :created, location: @offer_schedule }
      else
        format.html { render action: "new" }
        format.json { render json: @offer_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /offer_schedules/1
  # PUT /offer_schedules/1.json
  def update
    @offer_schedule = OfferSchedule.find(params[:id])

    respond_to do |format|
      if @offer_schedule.update_attributes(params[:offer_schedule])
        format.html { redirect_to @offer_schedule, notice: 'Offer schedule was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @offer_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offer_schedules/1
  # DELETE /offer_schedules/1.json
  def destroy
    @offer_schedule = OfferSchedule.find(params[:id])
    @offer_schedule.destroy

    respond_to do |format|
      format.html { redirect_to offer_schedules_url }
      format.json { head :no_content }
    end
  end
end
