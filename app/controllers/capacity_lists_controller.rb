class CapacityListsController < ApplicationController
  # GET /capacity_lists
  # GET /capacity_lists.json
  def index
    @capacity_lists = CapacityList.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @capacity_lists }
    end
  end

  # GET /capacity_lists/1
  # GET /capacity_lists/1.json
  def show
    @capacity_list = CapacityList.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @capacity_list }
    end
  end

  # GET /capacity_lists/new
  # GET /capacity_lists/new.json
  def new
    @capacity_list = CapacityList.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @capacity_list }
    end
  end

  # GET /capacity_lists/1/edit
  def edit
    @capacity_list = CapacityList.find(params[:id])
  end

  # POST /capacity_lists
  # POST /capacity_lists.json
  def create
    @capacity_list = CapacityList.new(params[:capacity_list])

    respond_to do |format|
      if @capacity_list.save
        format.html { redirect_to @capacity_list, notice: 'Capacity list was successfully created.' }
        format.json { render json: @capacity_list, status: :created, location: @capacity_list }
      else
        format.html { render action: "new" }
        format.json { render json: @capacity_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /capacity_lists/1
  # PUT /capacity_lists/1.json
  def update
    @capacity_list = CapacityList.find(params[:id])

    respond_to do |format|
      if @capacity_list.update_attributes(params[:capacity_list])
        format.html { redirect_to @capacity_list, notice: 'Capacity list was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @capacity_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /capacity_lists/1
  # DELETE /capacity_lists/1.json
  def destroy
    @capacity_list = CapacityList.find(params[:id])
    @capacity_list.destroy

    respond_to do |format|
      format.html { redirect_to capacity_lists_url }
      format.json { head :no_content }
    end
  end
end
