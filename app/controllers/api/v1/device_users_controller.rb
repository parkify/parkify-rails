class Api::V1::DeviceUsersController < ApplicationController
  # GET /device_users
  # GET /device_users.json
  def index
    @device_users = DeviceUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @device_users }
    end
  end

  # GET /device_users/1
  # GET /device_users/1.json
  def show
    @device_user = DeviceUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @device_user }
    end
  end

  # GET /device_users/new
  # GET /device_users/new.json
  def new
    @device_user = DeviceUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @device_user }
    end
  end

  # GET /device_users/1/edit
  def edit
    @device_user = DeviceUser.find(params[:id])
  end

  # POST /device_users
  # POST /device_users.json
  def create(options={})
    if (!current_user)
        format.html { render action: "new" }
        format.json { render json: {:user_status=>"not logged in"}, status: :unprocessable_entity }
    else
      @device = Device.where("device_uid=?", params[:device_uid]).first
      if(!@device)
        p 'Illegal. how are we posting to a device that doesnt exist? somethings been hacked!'
        format.html { render action: "new" }
        format.json { render json: {:device_status=>"not created in"}, status: :unprocessable_entity }
      end
      userid = current_user.id
      @device_user = DeviceUser.where("user_id=?", userid).first
      if (!@device_user)
        @device_user = DeviceUser.new(:device_id=>@device.id, :user_id=>userid, :last_used_at =>Time.now(), :created_at=>Time.now(), :updated_at=>Time.now())
      end
      if (@device_user.device_id != @device.id)
        @device_user.device_id = @device.id
        @device_user.last_used_at = Time.now()
        @device_user.updated_at = Time.now()
      end
      
      respond_to do |format|
       if @device_user.save
         format.html { redirect_to @device_user, notice: 'Device user was successfully created.' }
         format.json { render json: @device_user, status: :created, location: @device_user }
       else
          format.html { render action: "new" }
          format.json { render json: @device_user.errors, status: :unprocessable_entity }
        end
      end
    end
    end

  # PUT /device_users/1
  # PUT /device_users/1.json
  def update
    @device_user = DeviceUser.find(params[:id])

    respond_to do |format|
      if @device_user.update_attributes(params[:device_user])
        format.html { redirect_to @device_user, notice: 'Device user was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @device_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /device_users/1
  # DELETE /device_users/1.json
  def destroy
    @device_user = DeviceUser.find(params[:id])
    @device_user.destroy

    respond_to do |format|
      format.html { redirect_to device_users_url }
      format.json { head :no_content }
    end
  end
end
