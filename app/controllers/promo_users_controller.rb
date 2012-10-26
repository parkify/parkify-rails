class PromoUsersController < ApplicationController
  # GET /promo_users
  # GET /promo_users.json
  def index
    @promo_users = PromoUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @promo_users }
    end
  end

  # GET /promo_users/1
  # GET /promo_users/1.json
  def show
    @promo_user = PromoUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @promo_user }
    end
  end

  # GET /promo_users/new
  # GET /promo_users/new.json
  def new
    @promo_user = PromoUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @promo_user }
    end
  end

  # GET /promo_users/1/edit
  def edit
    @promo_user = PromoUser.find(params[:id])
  end

  # POST /promo_users
  # POST /promo_users.json
  def create
    @promo_user = PromoUser.new(params[:promo_user])

    respond_to do |format|
      if @promo_user.save
        format.html { redirect_to @promo_user, notice: 'Promo user was successfully created.' }
        format.json { render json: @promo_user, status: :created, location: @promo_user }
      else
        format.html { render action: "new" }
        format.json { render json: @promo_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /promo_users/1
  # PUT /promo_users/1.json
  def update
    @promo_user = PromoUser.find(params[:id])

    respond_to do |format|
      if @promo_user.update_attributes(params[:promo_user])
        format.html { redirect_to @promo_user, notice: 'Promo user was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @promo_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /promo_users/1
  # DELETE /promo_users/1.json
  def destroy
    @promo_user = PromoUser.find(params[:id])
    @promo_user.destroy

    respond_to do |format|
      format.html { redirect_to promo_users_url }
      format.json { head :no_content }
    end
  end
end
