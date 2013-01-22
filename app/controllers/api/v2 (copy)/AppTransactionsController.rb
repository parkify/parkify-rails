class Api::V2::AppTransactionsController < ApplicationController
  # GET /transactions
  # GET /transactions.json
  
  #before_filter :ensure_params_exist, :except => [:index, :show, :new, :edit, :create, :update, :destroy]
  
  # TODO: make checks for bad data in
 
   
  
  def index
    p 'idnex'
    @acceptances = []
    if(current_user)
      @acceptances = Acceptance.where("userid=? and (status=? or status = ?) and end_time> ?", current_user.id, "successfully paid", "payment pending", Time.now())
    end
    p "acceptances are "
    p @acceptances.as_json()
#respond_to do |format|
#format.html # index.html.erb
#@transactions = Transaction.all

    presenter = Api::V2::AcceptancesPresenter.new
    acceptances_json = @acceptances.map{|x| presenter.as_json(x)}

    p ["SENDING_JSON OF ACCEPTANCES", acceptances_json]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: acceptances_json }
      #format.json { render json: @acceptances.as_json() }
    end
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
    p 'show?'
    @acceptances = []
    if(current_user)
      if(params[:id])
        @acceptance = Acceptance.find(params[:id])
      else
        @acceptances = Acceptance.where("user_id=? and (status=? or status = ?) and end_time> ?", current_user.id, "successfully paid", "payment pending", Time.now())
      end
    end
    p "acceptances are "
    p @acceptances.as_json()

    presenter = Api::V2::AcceptancesPresenter.new
    acceptances_json = @acceptances.map{|x| presenter.as_json(x)}

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: acceptances_json }
    end
  end


  # GET /transactions/new
  # GET /transactions/new.json
  def new
    @transaction = Transaction.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transaction }
    end
  end

  # GET /transactions/1/edit
  def edit
    @transaction = Transaction.find(params[:id])
  end

  # POST /transactions
  # POST /transactions.json
  def create(options={})
    build_no_db(params[:transaction])
    p @acceptance
    thisaccept = nil
    if(params[:extend])
      userid = current_user.id
      acceptanceid = params[:acceptanceid]
      thisaccept=Acceptance.find(acceptanceid)
      p "checking an extend"
      if(thisaccept == nil || thisaccept.user_id!=userid)
            @acceptance.errors.add(:spot, "not available at this time")
            @acceptance.status = "failed"
      end 
    end    

    if(@acceptance.status == "failed" || !ApplicationController::resource_offer_handler.validate_reservation(@acceptance.resource_offer_id, @acceptance.start_time, @acceptance.end_time))
      @acceptance.errors.add(:spot, "not available at this time")
      @acceptance.status = "failed"
    end

    respond_to do |format|
      if @acceptance.status != "failed" and @acceptance.save and @acceptance.validate_and_charge() and @acceptance.save
        p thisaccept
        if(thisaccept)
          p "changing status to extended"
          thisaccept.status = "extended"
          thisaccept.save

          @acceptance.start_time = thisaccept.start_time
          @acceptance.save
        end
        presenter = Api::V2::AcceptancesPresenter.new
        acceptance_json = presenter.as_json(@acceptance)
        format.html { redirect_to @acceptance, notice: 'acceptance was successfully created.' }
        format.json { render json: {:acceptance => acceptance_json, :success=>true}, status: :created, location: @acceptance, }
      else
        format.html { render action: "new" }
        format.json { render json: {:success => false, :error=>@acceptance.errors}}
      end
    end
  end
  
  
  def preview
    build_no_db(params[:transaction])

    p @acceptance
    if(@acceptance.status == "failed")
      toSend = {:success => false, :price_string => @acceptance.errors.full_messages().first}
    else
      toSend = @acceptance.check_price(ApplicationController::resource_offer_handler)
    end

    respond_to do |format|
      if(toSend)
        format.html { redirect_to @acceptance, notice: 'acceptance was successfully created.' }
          format.json { render json: {:success => true, :message=>toSend}, status: :created, location: @acceptance, }
      else
        format.html { render action: "new" }
        format.json { render json: {:success => false}, status: :unprocessable_entity }
      end
    end
  end
  
  def build_no_db(params)
    params = JSON.parse(params)

    @acceptance = Acceptance.new({
      :status => "pending",
      :user_id => current_user.id,
      :start_time => Time.at(params["start_time"].to_f()),
      :end_time => Time.at(params["end_time"].to_f()),
    })

    if (params["end_time"] < params["start_time"] )
      @acceptance.errors.add(:reservation, "has invalid time")
      @acceptance.status = "failed"
    elsif (params["offer_ids"].length != 1)
      @acceptance.errors.add(:spot, "not available at this time")
      @acceptance.status = "failed"
    else
      @acceptance.resource_offer_id = params["offer_ids"][0].to_i
    end

    if (params["price_type"])
      @acceptance.price_type = params["price_type"]
      if(params["price_type"] == "flat_rate")
        @acceptance.price_name = params["flat_rate_name"]
      end
    else
      @acceptance.price_type = "hourly"
    end
    p ["SUPERTEST", params, @acceptance]
  end

  # PUT /transactions/1
  # PUT /transactions/1.json
  def update
    @transaction = Transaction.find(params[:id])

    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy

    respond_to do |format|
      format.html { redirect_to transactions_url }
      format.json { head :no_content }
    end
  end
  
  protected
  def ensure_params_exist
    return unless params[:transaction].blank?
    render :json=>{:success=>false, :message=>"missing transaction"}, :status=>422
  end

  def invalid_transaction
    render :json=> {:success=>false, :message=>"Error with transaction"}, :status=>401
  end
  
end