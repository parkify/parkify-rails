ENV['HIPCHAT_TOKEN'] |= 'f147a186b6297cee079680f284d9de'

HIPCHAT_API = HipChat::API.new(ENV['HIPCHAT_TOKEN'])


if(!ENV["STAGING_SERVER"])
  ENV['HIPCHAT_ROOM'] = 'Parkify Pulse'
else
  ENV['HIPCHAT_ROOM'] = 'Parkify Pulse Dev'
end

