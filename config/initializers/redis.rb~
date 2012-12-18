config = YAML::load(File.open("#{Rails.root}/config/redis.yml"))[Rails.env]

Resque.redis = Redis.new(:host => config['host'], :port => config['port'])

Ohm.connect({:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true})



#ENV["REDISTOGO_URL"] ||= "redis://redistogo:b78903562b573eca1f7245bfd29a8986@spadefish.redistogo.com:9247/"
#
#uri = URI.parse(ENV["REDISTOGO_URL"])
#Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => #uri.password, :thread_safe => true)
#
#Dir[File.join(Rails.root, 'app', 'jobs', '*.rb')].each { |file| require file }
