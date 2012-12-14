ENV["REDISTOGO_URL"] ||= "redis://redistogo:b78903562b573eca1f7245bfd29a8986@spadefish.redistogo.com:9247/"

uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)

Ohm.connect(:url => ENV["REDISTOGO_URL"])


