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
    
    start_time_parts << request["time_zone"]
    end_time_parts << request["time_zone"]

    start_time = Time.new(*start_time_parts)
    end_time = Time.new(*end_time_parts)

    if(@request)
      UserMailer.user_aquisition_query_email(start_time, end_time, request[:email]).deliver
    end
  end
end
