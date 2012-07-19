class ParkingSpotsController < ApplicationController
  def new
  end

  # POST /users
  # POST /users.json
  def create
    @location = Location.new(params[:location])
    @price_plan = Location.new(params[:price_plan])
    @resource = Location.new(params[:price_plan])
    @user = User.find_by_email(params[:user][:email])
    
    @resource.user_id = @user_id
    
    respond_to do |format|
      if @resource.save
        @location.resource_id = @resource.id
        @price_plan.resource_id = @resource.id
        if @location.save and @price_plan.save
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render json: @user, status: :created, location: @user }
        else
          format.html { render action: "new" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
end
