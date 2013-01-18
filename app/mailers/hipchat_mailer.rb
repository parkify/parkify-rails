class HipchatMailer

  def post(message)
    if(HIPCHAT_API)
      HIPCHAT_API.rooms_message(ENV['HIPCHAT_ROOM'], 'System', message)
    end
  end
end
