class Api::V3::AccountController < ApplicationController
  # GET /users
  # GET /users.json
  
  respond_to :json
  
  def index
    @users = User.all

    respond_to do |format|
      #format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = current_user
    respond_to do |format|
      #format.html # show.html.erb
        format.json { render json: {:user=>Api::V3::UsersPresenter.new().as_json(@user), :success=>true } }
    end
  end

  def show_trial
    @device = Device.find_by_device_uid(params[:device_uid])
    if(@device)
      @user = @device.trial_account
    end
    respond_to do |format|
      #format.html # show.html.erb
      if(@user)
        format.json { render json: {:user=>Api::V3::UsersPresenter.new().as_json(@user), :success=>true } }
      else
        format.json { render json: {:success=>false } }
      end
    end
  end


  #ok, ok, so I need to decide what to do if the user doesn't have the auth token. I suppose I give them that when they first open the app if they have a trial account? If they ONLY have a trial account tied to that device?


  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      #format.html # new.html.erb
      format.json { render json: Api::V3::UsersPresenter.new().as_json(@user) }
    end
  end

  # GET /users/1/edit
  def edit
    @user = current_user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(JSON.parse(params[:user]))

    respond_to do |format|
      if @user.save
        #format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render json: Api::V3::UsersPresenter.new().as_json(@user), status: :created, location: @user }
      else
        #format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def account
    self.update
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = current_user
    respond_to do |format|
      puts "1"
      if @user.update_attributes(JSON.parse(params[:user]))
        puts "2"  
        #format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render json: {:user=>Api::V3::UsersPresenter.new().as_json(@user), :success=>true}, location: @user }
      else
        puts "3"
        #format.html { render action: "edit" }
        format.json { render json: {:error=>@user.errors}, status: :unprocessable_entity }
      end
    end
  end
  
  def activate_card
    @user = current_user
    @card = Card.find_by_id(params[:id])
    
    respond_to do |format|
      puts "1"
      if @user.activate_card(@card)
        puts "2"  
        #format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render json: {:card=>@card, :success=>true}, location: @user }
      else
        puts "3"
        #format.html { render action: "edit" }
          format.json { render json: {:error=>@user.errors}, status: :unprocessable_entity }
      end
    end
  end
  
  def add_card
    @user = current_user
    
    respond_to do |format|
      if @user.save_with_new_card!(params[:stripe_token_id])
        #format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render json: {:card=>@user.cards.order(:created_at).last, :success=>true}, location: @user }
      else
        #format.html { render action: "edit" }
          format.json { render json: {:error=>@user.errors}, status: :unprocessable_entity }
      end
    end
  end
  
  def add_car
    @user = current_user
    respond_to do |format|
      if @user.save_with_new_car!(params[:license_plate_number])
        #format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render json: {:car=>@user.cars.order(:created_at).last, :success=>true}, location: @user }
      else
        p "foo"
        #format.html { render action: "edit" }
          format.json { render json: {:error=>@user.errors}, status: :unprocessable_entity }
      end
    end
  end
  
  def add_promo
    @user = current_user
    respond_to do |format|
      @promo_user = @user.save_with_new_promo!(params[:code_text])
      p @promo_user
      if @promo_user
        #format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render json: {:promo=>@promo_user, :success=>true}, location: @user }
      else
        p "foo"
        #format.html { render action: "edit" }
        p @user.errors
          format.json { render json: {:error=>@user.errors}, status: :unprocessable_entity }
      end
    end
  end
  
  def update_cars
    @user = current_user
    
    respond_to do |format|
    err = @user.update_cars(JSON.parse(params[:cars]))
      if !err
        #format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render json: {:success=>true}, location: @user }
      else
        #format.html { render action: "edit" }
          format.json { render json: {:error=>err}, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = current_user
    @user.destroy

    respond_to do |format|
      #format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  
  def update_password
    @user = User.find(current_user.id)
    respond_to do |format|
      if @user.update_attributes(JSON.parse(params[:user]))
        # Sign in the user by passing validation in case his password changed
        sign_in @user, :bypass => true
        format.json { render json: {:user=>Api::V3::UsersPresenter.new().as_json(@user), :auth_token=>@user.authentication_token, :success=>true}, location: @user }
      else
        p @user.errors
          format.json { render json: {:error=>@user.errors}, status: :unprocessable_entity }
      end
    end
  end
  
  
  def reset_password
    @user = User.find_by_email(params[:email])
    respond_to do |format|
      if @user
        @user.send_reset_password_instructions
        sign_out @user
        format.json { render json: {:success=>true}, location: @user }
       else
        format.json { render json: {:success=>false}, status: :unprocessable_entity }
      end
    end
  end

  def fill_trial_account
    @user = current_user
    
    if(!@user || !@user.trial?)
      respond_to do |format|
        format.json { render json: {:success=>false}, status: :unprocessable_entity }
      end
    else
      @promo_user = nil
      if(params[:code_text])
        @promo_user = @user.save_with_new_promo!(params[:code_text])
        success = !(@promo_user.nil?)
      else
        @user.phone_number = params[:phone_number]
        success = @user.save
      end

      respond_to do |format|
        if (success)
         format.json { render json: {:success=>false}, status: :unprocessable_entity }
        end
      end

      if (success)
        format.json { render json: {:promo=>@promo_user, :user=>Api::V3::UsersPresenter.new().as_json(@user), :success=>true}, location: @user }
      else
        format.json { render json: {:error=>@user.errors}, status: :unprocessable_entity }
      end
    end
  end
  
  def check_code_text
    @code = Code.find_by_code_text(params[:code_text])
    if(!@code || !@code.promo)
      respond_to do |format|
        format.json { render json: {:success=>false}, status: :unprocessable_entity }
      end
    else
      @promo = @code.promo
      respond_to do |format|
        if(@promo.active?)
          format.json { render json: {:success=>true, :display_string => @promo.short_description} }
        else
          format.json { render json: {:success=>false}, status: :unprocessable_entity }
        end
      end
      
    end

  end
  
end
