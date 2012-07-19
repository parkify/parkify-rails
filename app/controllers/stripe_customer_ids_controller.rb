class StripeCustomerIdsController < ApplicationController
  # GET /stripe_customer_ids
  # GET /stripe_customer_ids.json
  def index
    @stripe_customer_ids = StripeCustomerId.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stripe_customer_ids }
    end
  end

  # GET /stripe_customer_ids/1
  # GET /stripe_customer_ids/1.json
  def show
    @stripe_customer_id = StripeCustomerId.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @stripe_customer_id }
    end
  end

  # GET /stripe_customer_ids/new
  # GET /stripe_customer_ids/new.json
  def new
    @stripe_customer_id = StripeCustomerId.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @stripe_customer_id }
    end
  end

  # GET /stripe_customer_ids/1/edit
  def edit
    @stripe_customer_id = StripeCustomerId.find(params[:id])
  end

  # POST /stripe_customer_ids
  # POST /stripe_customer_ids.json
  def create
    @stripe_customer_id = StripeCustomerId.new(params[:stripe_customer_id])

    respond_to do |format|
      if @stripe_customer_id.save
        format.html { redirect_to @stripe_customer_id, notice: 'Stripe customer was successfully created.' }
        format.json { render json: @stripe_customer_id, status: :created, location: @stripe_customer_id }
      else
        format.html { render action: "new" }
        format.json { render json: @stripe_customer_id.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /stripe_customer_ids/1
  # PUT /stripe_customer_ids/1.json
  def update
    @stripe_customer_id = StripeCustomerId.find(params[:id])

    respond_to do |format|
      if @stripe_customer_id.update_attributes(params[:stripe_customer_id])
        format.html { redirect_to @stripe_customer_id, notice: 'Stripe customer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @stripe_customer_id.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stripe_customer_ids/1
  # DELETE /stripe_customer_ids/1.json
  def destroy
    @stripe_customer_id = StripeCustomerId.find(params[:id])
    @stripe_customer_id.destroy

    respond_to do |format|
      format.html { redirect_to stripe_customer_ids_url }
      format.json { head :no_content }
    end
  end
end
