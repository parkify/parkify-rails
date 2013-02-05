class AppQueryController < ApplicationController
  def user_aquisition_new
    respond_to do |format|
      format.html
      format.json { render json: [] }
    end
  end

  def user_aquisition_create
    request = params[:request]
    start_time_parts = []
    end_time_parts = []
    for i in 1..5 do
      start_time_parts << request["start_time(#{i}i)"].to_i
      end_time_parts << request["end_time(#{i}i)"].to_i
    end
    #add seconds
    start_time_parts << 0
    end_time_parts << 0
    #add time zone
    utc_offset =  ActiveSupport::TimeZone.new(request[:time_zone]).utc_offset
    start_time_parts << utc_offset
    end_time_parts << utc_offset

    start_time = Time.new(*start_time_parts)
    end_time = Time.new(*end_time_parts)

    if(@request)
      UserMailer.user_aquisition_query_email(start_time, end_time, request[:email]).deliver
    end
  end
end
