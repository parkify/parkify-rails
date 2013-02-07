class Api::V3::DevicesController < ApplicationController
  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @devices }
    end
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
    @device = Device.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @device }
    end
  end

  # GET /devices/new
  # GET /devices/new.json
  def new
    @device = Device.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @device }
    end
  end

  # GET /devices/1/edit
  def edit
    @device = Device.find(params[:id])
  end

  # POST /devices
  # POST /devices.json
  # Update/Add device record. Check whether or not a trial account is needed to be generated.
  def create(options={})
    new_device = false
    @device = Device.find_or_initialize_by_device_uid(params[:device_uid], :last_used_at => Time.now, :push_token_id => "")
    if(params[:push_token_id])
      @device.push_token_id = params[:push_token_id]
    end
    @device.device_type = params[:devicetype]  
    @device.last_used_at = Time.now

    if(@device.save)
      if (current_user)	
        p 'user logged in'
        device_user = @device.device_users.find_or_initialize_by_user_id(current_user.id, :last_used_at => Time.now)
        device_user.last_used_at = Time.now()
        device_user.save
      else
        @device = Device.find(@device)
        if(@device.users.count == 0)
          new_device = true
        end
      end
    else
      
    end
    respond_to do |format|
      if @device.save
        format.html { redirect_to @device, notice: 'Device was successfully created.' }
        if(@device.has_trial_account)
          format.json {render json: {:isNew=>new_device, :success=>true, :device=>@device.as_json(), :auth_token=>@device.users.first.authentication_token}, status: :created}
        else
          format.json {render json: {:isNew=>new_device, :success=>true, :device=>@device.as_json()}, status: :created}
        end
#format.json { render json: @device, status: :created, isNew: isNew, location: @device }
      else
        format.html { render action: "new" }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /devices/1
  # PUT /devices/1.json
  def update
    @device = Device.find(params[:id])

    respond_to do |format|
      if @device.update_attributes(params[:device])
        format.html { redirect_to @device, notice: 'Device was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device = Device.find(params[:id])
    @device.destroy

    respond_to do |format|
      format.html { redirect_to devices_url }
      format.json { head :no_content }
    end
  end
end
