class PromosController < ApplicationController
  # GET /promos
  # GET /promos.json
  def index
    @promos = Promo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @promos }
    end
  end

  # GET /promos/1
  # GET /promos/1.json
  def show
    @promo = Promo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @promo }
    end
  end

  # GET /promos/new
  # GET /promos/new.json
  def new
    @promo = Promo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @promo }
    end
  end

  # GET /promos/1/edit
  def edit
    @promo = Promo.find(params[:id])
  end

  # POST /promos
  # POST /promos.json
  def create
    @promo = Promo.new(params[:promo])

    respond_to do |format|
      if @promo.save
        format.html { redirect_to @promo, notice: 'Promo was successfully created.' }
        format.json { render json: @promo, status: :created, location: @promo }
      else
        format.html { render action: "new" }
        format.json { render json: @promo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /promos/1
  # PUT /promos/1.json
  def update
    @promo = Promo.find(params[:id])

    respond_to do |format|
      if @promo.update_attributes(params[:promo])
        format.html { redirect_to @promo, notice: 'Promo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @promo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /promos/1
  # DELETE /promos/1.json
  def destroy
    @promo = Promo.find(params[:id])
    @promo.destroy

    respond_to do |format|
      format.html { redirect_to promos_url }
      format.json { head :no_content }
    end
  end
end
