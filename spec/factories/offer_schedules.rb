# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :offer_schedule do
    resource_offer_id 1
    start_date "2012-11-21 05:33:08"
    end_date "2012-11-21 05:33:08"
    recurrance_type "MyString"
    relative_start "2012-11-21 05:33:08"
    duration 1.5
    price_per_hour 1.5
    capacity 1.5
  end
end
