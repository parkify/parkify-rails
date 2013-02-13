#!/usr/local/bin/ruby
require 'rake'
require 'rest_client'
require 'active_support'

Dir.new(File.dirname(__FILE__)).reject{|x| [".",".."].include? x}.each do |name|
  if (FileTest.directory?(name))
    begin
    FileUtils.cd name
    rescue
      next
    end
    begin
      if(Dir.new('.').to_a.include?("update_images.rb"))
        command = "./update_images.rb #{ARGV.join(" ")}"
        system(command)
      end
    rescue
    end
    FileUtils.cd '..'
  end
end
