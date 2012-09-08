class Api::V1::AppTransactionsController < ApplicationController
  # GET /transactions
  # GET /transactions.json
  
  #before_filter :ensure_params_exist, :except => [:index, :show, :new, :edit, :create, :update, :destroy]
  
  # TODO: make checks for bad data in
 
   
  
  def index
    @transactions = Transaction.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @transactions }
    end
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
    @transaction = Transaction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transaction }
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
  def create
    @acceptance = Acceptance.build_from_api(params[:transaction])
    respond_to do |format|
      if @acceptance != nil and @acceptance.save
        p "yes1!----------------------------"
        if(@acceptance.add_offers_and_charge_from_api(params[:transaction]) and acceptance.save!)
          p "yes2!----------------------------" 
          format.html { redirect_to @acceptance, notice: 'acceptance was successfully created.' }
          format.json { render json: {:acceptance => @acceptance, :success=>true}, status: :created, location: @acceptance, }
        else
          p "no2!----------------------------" 
          format.html { render action: "new" }
          puts @acceptance.status
          format.json { render json: @acceptance.errors, status: :unprocessable_entity }
        end
      else
        p "yes2!----------------------------" 
        format.html { render action: "new" }
        puts @acceptance.status
        format.json { render json: @acceptance.errors, status: :unprocessable_entity }
      end
    end
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
