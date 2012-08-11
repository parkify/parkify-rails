class QuickPropertiesController < ApplicationController
  # GET /quick_properties
  # GET /quick_properties.json
  def index
    @quick_properties = QuickProperty.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quick_properties }
    end
  end

  # GET /quick_properties/1
  # GET /quick_properties/1.json
  def show
    @quick_property = QuickProperty.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quick_property }
    end
  end

  # GET /quick_properties/new
  # GET /quick_properties/new.json
  def new
    @quick_property = QuickProperty.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quick_property }
    end
  end

  # GET /quick_properties/1/edit
  def edit
    @quick_property = QuickProperty.find(params[:id])
  end

  # POST /quick_properties
  # POST /quick_properties.json
  def create
    @quick_property = QuickProperty.new(params[:quick_property])

    respond_to do |format|
      if @quick_property.save
        format.html { redirect_to @quick_property, notice: 'Quick property was successfully created.' }
        format.json { render json: @quick_property, status: :created, location: @quick_property }
      else
        format.html { render action: "new" }
        format.json { render json: @quick_property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /quick_properties/1
  # PUT /quick_properties/1.json
  def update
    @quick_property = QuickProperty.find(params[:id])

    respond_to do |format|
      if @quick_property.update_attributes(params[:quick_property])
        format.html { redirect_to @quick_property, notice: 'Quick property was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quick_property.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quick_properties/1
  # DELETE /quick_properties/1.json
  def destroy
    @quick_property = QuickProperty.find(params[:id])
    @quick_property.destroy

    respond_to do |format|
      format.html { redirect_to quick_properties_url }
      format.json { head :no_content }
    end
  end
end
