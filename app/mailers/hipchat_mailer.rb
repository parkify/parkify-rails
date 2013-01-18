class HipchatMailer

  def self.post(message, color="green", notify=false)
    if(HIPCHAT_API)
      HIPCHAT_API.rooms_message(ENV['HIPCHAT_ROOM'], 'System', message, :color=>color, :notify=>notify)
    end
  end

end
