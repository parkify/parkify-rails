# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :price_interval do
    start_time "2012-08-15 09:11:11"
    end_time "2012-08-15 09:11:11"
    price_per_hour ""
    price_plan_id ""
  end
end
