class ParkingSpotsController < ApplicationController

  before_filter :authenticate_user!

  def new
  end

  # POST /users
  # POST /users.json
  def create
    @resource = Resource.new(params[:resource])
    #@user = User.find_by_email(params[:user][:email])
    
    @resource.user_id = current_user.id
    @resource.capacity = 1.0
    
    respond_to do |format|
      if @resource.save
        @location = @resource.build_location(params[:location])
        @price_plan = @resource.build_price_plan(params[:price_plan])
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
