# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :offer_schedule_exception do
    resource_offer_id 1
    exception_type "MyString"
    start "2012-11-21 05:40:48"
    duration 1.5
    price 1.5
    capacity 1.5
  end
end
