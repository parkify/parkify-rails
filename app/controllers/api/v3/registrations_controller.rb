class Api::V3::RegistrationsController < ApplicationController
  
  respond_to :json
  
  #create a new user through json (with credit card info)s
  def create
    if(params["trial"]	)
      p ["GOT HERE"]
      @user = User.build_trial_account
      @user.phone_number = JSON.parse(params[:user])["phone_number"]	

      if(JSON.parse(params[:user])["code_text"])
        p ["Got here"]
        success = @user.save_with_new_promo!(JSON.parse(params[:user])["code_text"])
      else
        @user.credit = 500
        success = @user.save
      end
      
      if(success)
        render :json=> {:success=>true, :user=>Api::V3::UsersPresenter.new().as_json(@user), :auth_token=>@user.authentication_token}, :status=>201
      else
        if(@user.id)
          @user.destroy
        end
        warden.custom_failure!
        render :json=>{:success=>false, :error=>@user.errors}, :status=>422

      end
    else
      @user = current_user
      if(@user)
        #Promote account
        @user.assign_attributes(JSON.parse(params[:user]))
        @user.account_type = "standard"
      else
        @user = User.new(JSON.parse(params[:user]))
      end

      success = false
      if @user.cars.count > 0
        success = @user.save_with_new_card!(params[:stripe_token_id])
      else
        success = @user.save_with_card_and_car!(params[:stripe_token_id], params[:license_plate_number])
      end
      
      if success
        logger.info "err1..."
        #Return the results
        lpn = @user.cars.first.license_plate_number
        last_four_digits = Stripe::Customer.retrieve(@user.cards[0].customer_id).active_card.last4
        render :json=> {:success=>true, :user=>Api::V3::UsersPresenter.new().as_json(@user), :auth_token=>@user.authentication_token, :license_plate_number => lpn, :last_four_digits => last_four_digits }, :status=>201
        #render :json=>{:success=>true, :auth_token=>@user.authentication_token, :user=>@user.email}
        return
      else
        logger.info "err2..."
        warden.custom_failure!
        render :json=>{:success=>false, :error=>@user.errors}, :status=>422
      end
    end
  
  end
end
