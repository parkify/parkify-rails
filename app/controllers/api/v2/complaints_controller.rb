class Api::V2::ComplaintsController < ApplicationController
  # GET /complaints
  # GET /complaints.json
  def index
    @complaints = Complaint.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @complaints }
    end
  end

  # GET /complaints/1
  # GET /complaints/1.json
  def show
    @complaint = Complaint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @complaint }
    end
  end

  # GET /complaints/new
  # GET /complaints/new.json
  def new
    @complaint = Complaint.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @complaint }
    end
  end

  # GET /complaints/1/edit
  def edit
    @complaint = Complaint.find(params[:id])
  end

  # POST /complaints
  # POST /complaints.json
  def create
    info= JSON.parse(params[:complaint])
    @complaint = Complaint.new(info)
    @complaint.user_id = current_user.id
    getResourceid = @complaint.resource_offer_id
    resource = ResourceOffer.find(getResourceid)
    acceptid = params[:acceptanceid]
    respond_to do |format|
      if @complaint.save
        if(resource)
          if (params[:shouldCancel] == "1")
            resource.active=false
          end
          UserMailer.trouble_with_spot_email(resource, @complaint, current_user, params[:shouldCancel]).deliver
          HipchatMailer::post("User had a problem!<br/>Spot: #{@complaint.resource_offer.sign_id @ @complaint.resource_offer.location_address}<br/>User: #{@complaint.user.first_name} #{@complaint.user.last_name}<br/>Problem: #{@complaint.description}")
          resource.save
        end
        acceptancetorefund = Acceptance.find(acceptid)
        if(acceptancetorefund)
          responsestring = acceptancetorefund.refund_payment()
          format.html { redirect_to @complaint, notice: 'Complaint was successfully created.' }
          format.json { render json: {:response=>responsestring, :success=>true}, status: :created, location: @complaint }
        
        else
          format.html { render action: "new" }
          format.json { render json: {:error=>"There is no acceptance with tht record"}, status: :unprocessable_entity }
          
        end
      else
        format.html { render action: "new" }
        format.json { render json: @complaint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /complaints/1
  # PUT /complaints/1.json
  def update
    @complaint = Complaint.find(params[:id])

    respond_to do |format|
      if @complaint.update_attributes(params[:complaint])
        format.html { redirect_to @complaint, notice: 'Complaint was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @complaint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /complaints/1
  # DELETE /complaints/1.json
  def destroy
    @complaint = Complaint.find(params[:id])
    @complaint.destroy

    respond_to do |format|
      format.html { redirect_to complaints_url }
      format.json { head :no_content }
    end
  end
end
