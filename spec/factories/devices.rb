# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :device do
    device_uid "MyString"
    push_token_id "MyString"
    device_type "MyString"
    last_used_at "2012-11-21 06:42:14"
  end
end
