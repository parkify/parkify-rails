class PaymentInfosController < ApplicationController
  # GET /payment_infos
  # GET /payment_infos.json
  def index
    @payment_infos = PaymentInfo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payment_infos }
    end
  end

  # GET /payment_infos/1
  # GET /payment_infos/1.json
  def show
    @payment_info = PaymentInfo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @payment_info }
    end
  end

  # GET /payment_infos/new
  # GET /payment_infos/new.json
  def new
    @payment_info = PaymentInfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment_info }
    end
  end

  # GET /payment_infos/1/edit
  def edit
    @payment_info = PaymentInfo.find(params[:id])
  end

  # POST /payment_infos
  # POST /payment_infos.json
  def create
    @payment_info = PaymentInfo.new(params[:payment_info])

    respond_to do |format|
      if @payment_info.save
        format.html { redirect_to @payment_info, notice: 'Payment info was successfully created.' }
        format.json { render json: @payment_info, status: :created, location: @payment_info }
      else
        format.html { render action: "new" }
        format.json { render json: @payment_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /payment_infos/1
  # PUT /payment_infos/1.json
  def update
    @payment_info = PaymentInfo.find(params[:id])

    respond_to do |format|
      if @payment_info.update_attributes(params[:payment_info])
        format.html { redirect_to @payment_info, notice: 'Payment info was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @payment_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_infos/1
  # DELETE /payment_infos/1.json
  def destroy
    @payment_info = PaymentInfo.find(params[:id])
    @payment_info.destroy

    respond_to do |format|
      format.html { redirect_to payment_infos_url }
      format.json { head :no_content }
    end
  end
end
