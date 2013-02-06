class Api::V3::RegistrationsController < ApplicationController
  
  respond_to :json
  
  #create a new user through json (with credit card info)s
  def create

    p ["params, params[:trial], params[\"trial\"]", params, params[:trial], params["trial"]]
    if(params["trial"]	)
      p ["GOT HERE"]
      @user = User.build_trial_account
      @user.phone_number = JSON.parse(params[:user])[:phone_number]	

      if(params["code_text"])
        success = @user.save_with_new_promo!(params[:code_text])
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

      @user = User.new(JSON.parse(params[:user]))



      logger.info "Beginning registration..."
      
      if @user.save_with_card_and_car!(params[:stripe_token_id], params[:license_plate_number])
        logger.info "err1..."
        #Return the results
        lpn = @user.cars.first.license_plate_number
        last_four_digits = Stripe::Customer.retrieve(@user.cards[0].customer_id).active_card.last4
        render :json=> {:success=>true, :user=>Api::V3::UsersPresenter.new().as_json(@user), :auth_token=>@user.authentication_token, :license_plate_number => lpn, :last_four_digits => last_four_digits }, :status=>201
        #render :json=>{:success=>true, :auth_token=>@user.authentication_token, :user=>@user.email}
        return
      else
        if(@user.id)
          @user.destroy
        end
        logger.info "err2..."
        warden.custom_failure!
        render :json=>{:success=>false, :error=>@user.errors}, :status=>422
      end
    end
  
  end
end
