class OfferScheduleExceptionsController < ApplicationController
  # GET /offer_schedule_exceptions
  # GET /offer_schedule_exceptions.json
  def index
    @offer_schedule_exceptions = OfferScheduleException.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @offer_schedule_exceptions }
    end
  end

  # GET /offer_schedule_exceptions/1
  # GET /offer_schedule_exceptions/1.json
  def show
    @offer_schedule_exception = OfferScheduleException.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @offer_schedule_exception }
    end
  end

  # GET /offer_schedule_exceptions/new
  # GET /offer_schedule_exceptions/new.json
  def new
    @offer_schedule_exception = OfferScheduleException.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @offer_schedule_exception }
    end
  end

  # GET /offer_schedule_exceptions/1/edit
  def edit
    @offer_schedule_exception = OfferScheduleException.find(params[:id])
  end

  # POST /offer_schedule_exceptions
  # POST /offer_schedule_exceptions.json
  def create
    @offer_schedule_exception = OfferScheduleException.new(params[:offer_schedule_exception])

    respond_to do |format|
      if @offer_schedule_exception.save
        format.html { redirect_to @offer_schedule_exception, notice: 'Offer schedule exception was successfully created.' }
        format.json { render json: @offer_schedule_exception, status: :created, location: @offer_schedule_exception }
      else
        format.html { render action: "new" }
        format.json { render json: @offer_schedule_exception.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /offer_schedule_exceptions/1
  # PUT /offer_schedule_exceptions/1.json
  def update
    @offer_schedule_exception = OfferScheduleException.find(params[:id])

    respond_to do |format|
      if @offer_schedule_exception.update_attributes(params[:offer_schedule_exception])
        format.html { redirect_to @offer_schedule_exception, notice: 'Offer schedule exception was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @offer_schedule_exception.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offer_schedule_exceptions/1
  # DELETE /offer_schedule_exceptions/1.json
  def destroy
    @offer_schedule_exception = OfferScheduleException.find(params[:id])
    @offer_schedule_exception.destroy

    respond_to do |format|
      format.html { redirect_to offer_schedule_exceptions_url }
      format.json { head :no_content }
    end
  end
end
