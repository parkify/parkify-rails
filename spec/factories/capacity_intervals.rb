# Read about factories at https://github.com/thoughtbot/factory_girl
#require 'spec_helper'

FactoryGirl.define do
  factory :capacity_interval do
    start_time {Time.at(0)}
    end_time {Time.at(1)}
    capacity 1
    capacity_list_id nil
  end
end
#
#Factory.define :capacity_interval do |ci|
#  ci.start_time { Time.at(0) }
#  ci.end_time { Time.at(1) }
#  ci.capacity 1
#  ci.capacity_list_id nil
#end
