class Api::V1::AccountController < ApplicationController
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
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      #format.html # new.html.erb
      format.json { render json: @user }
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
        format.json { render json: @user, status: :created, location: @user }
      else
        #format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
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
        format.json { render json: {:user=>@user, :success=>true}, location: @user }
      else
        puts "3"
        #format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def activate_card
    @user = current_user
    @card = StripeCustomerId.find_by_id(params[:id])
    
    respond_to do |format|
      puts "1"
      if @user.activate_card(@card)
        puts "2"  
        #format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render json: {:card=>@card, :success=>true}, location: @user }
      else
        puts "3"
        #format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def add_card
    @user = current_user
    
    respond_to do |format|
      if @user.save_with_new_card!(params[:stripe_token_id])
        #format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render json: {:card=>@user.stripe_customer_ids.order(:created_at).last, :success=>true}, location: @user }
      else
        #format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
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
        format.json { render json: @user.errors, status: :unprocessable_entity }
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
        format.json { render json: @user.errors, status: :unprocessable_entity }
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
        format.json { render json: err, status: :unprocessable_entity }
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
end
