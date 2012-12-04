# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :device_user do
    device_id 1
    user_id 1
    last_used_at "2012-11-21 06:44:42"
  end
end
