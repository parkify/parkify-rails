class AppQueryController < ApplicationController
  def user_aquisition_new
    respond_to do |format|
      format.html
      format.json { render json: [] }
    end
  end

  def user_aquisition_create
    @request = params[:request]
    @request[:start_time] -= ActiveSupport::TimeZone.new(@request[:time_zone]).utc_offset
    @request[:end_time] -= ActiveSupport::TimeZone.new(@request[:time_zone]).utc_offset

    if(@request)
      UserMailer.user_aquisition_query_email(@request[:start_time], @request[:start_time], @request[:email]).deliver
    end
  end
end
