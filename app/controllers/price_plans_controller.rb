class PricePlansController < ApplicationController
  # GET /price_plans
  # GET /price_plans.json
  def index
    @price_plans = PricePlan.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @price_plans }
    end
  end

  # GET /price_plans/1
  # GET /price_plans/1.json
  def show
    @price_plan = PricePlan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @price_plan }
    end
  end

  # GET /price_plans/new
  # GET /price_plans/new.json
  def new
    @price_plan = PricePlan.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @price_plan }
    end
  end

  # GET /price_plans/1/edit
  def edit
    @price_plan = PricePlan.find(params[:id])
  end

  # POST /price_plans
  # POST /price_plans.json
  def create
    @price_plan = PricePlan.new(params[:price_plan])

    respond_to do |format|
      if @price_plan.save
        format.html { redirect_to @price_plan, notice: 'Price plan was successfully created.' }
        format.json { render json: @price_plan, status: :created, location: @price_plan }
      else
        format.html { render action: "new" }
        format.json { render json: @price_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /price_plans/1
  # PUT /price_plans/1.json
  def update
    @price_plan = PricePlan.find(params[:id])

    respond_to do |format|
      if @price_plan.update_attributes(params[:price_plan])
        format.html { redirect_to @price_plan, notice: 'Price plan was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @price_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /price_plans/1
  # DELETE /price_plans/1.json
  def destroy
    @price_plan = PricePlan.find(params[:id])
    @price_plan.destroy

    respond_to do |format|
      format.html { redirect_to price_plans_url }
      format.json { head :no_content }
    end
  end
end
