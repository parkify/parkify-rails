class Api::V2::SessionsController < ApplicationController
  #before_filter :authenticate_user!, :except => [:create, :destroy]
  before_filter :ensure_params_exist
  respond_to :json
  
  def create
    user_login = JSON.parse(params[:user_login])
    resource = User.find_for_database_authentication(:email=>user_login["email"])
    return invalid_login_attempt unless resource

    if resource.valid_password?(user_login["password"])
      sign_in(:user, resource)
      @user = resource
      resource.ensure_authentication_token!
      lpn = @user.cars.first.license_plate_number
      last_four_digits = @user.active_card.last4
      render :json=> {:success=>true, :user=>Api::V2::UsersPresenter.new().as_json(@user), :auth_token=>resource.authentication_token, :license_plate_number => lpn, :last_four_digits => last_four_digits }
      return
    end
    invalid_login_attempt
  end
  
  def destroy
    user_login = JSON.parse(params[:user_login])
    resource = User.find_for_database_authentication(:email => user_login["email"])
    resource.authentication_token = nil
    resource.save
    render :json=> {:success=>true}
  end

  protected
  def ensure_params_exist
    return unless params[:user_login].blank?
    warden.custom_failure!
    render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status=>422
  end

  def invalid_login_attempt
    warden.custom_failure!
    render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
  end
end
