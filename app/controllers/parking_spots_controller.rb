class ParkingSpotsController < ApplicationController
  def new
  end

  # POST /users
  # POST /users.json
  def create
    @location = Location.new(params[:location])
    @price_plan = PricePlan.new(params[:price_plan])
    @resource = Resource.new(params[:price_plan])
    @user = User.find_by_email(params[:user][:email])
    
    @resource.user_id = @user.id
    
    respond_to do |format|
      if @resource.save
        @location.resource_id = @resource.id
        @price_plan.resource_id = @resource.id
        if @location.save and @price_plan.save
          format.html { redirect_to @resource, notice: 'Parking Spot was successfully created.' }
          format.json { render json: @resource, status: :created, location: @resource }
        else
          format.html { render action: "new" }
          format.json { render json: @resource.errors, status: :unprocessable_entity }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end
end
