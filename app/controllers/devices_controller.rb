class DevicesController < ApplicationController
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
  def create(options={})
    isNew=false
    @device = Device.where("device_uid=?", params[:device_uid]).first
    if (!@device)
      isNew=true
      @device = Device.new(:device_uid=>params[:device_uid], :push_token_id=> params[:push_token_id], :last_used_at =>Time.now(), :created=>Time.now(), :updated_at=>Time.now())
    end
    @device.push_token_id = params[:push_token_id]
    @device.device_type = params[:devicetype]
    if (current_user)
      userid = current_user.id
      p 'user logged in'
      device_user = DeviceUser.where("user_id=?", userid).first
      if(!device_user)
        device_user = DeviceUser.new(:device_id=>@device.id, :user_id=>userid, :last_used_at =>Time.now(), :created_at=>Time.now(), :updated_at=>Time.now())
      end
      if (device_user.device_id != @device.id)
        device_user.device_id = @device.id
        device_user.last_used_at = Time.now()
        device_user.updated_at = Time.now()
      end
      p 'saving new user device record'
      device_user.save()
    end
    respond_to do |format|
      if @device.save
        format.html { redirect_to @device, notice: 'Device was successfully created.' }
        format.json {render json: {:isNew=>isNew, :success=>true, :device=>@device.as_json()}, status: :created}
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
