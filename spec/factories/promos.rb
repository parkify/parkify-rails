# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :promo do
    name "MyText"
    description "MyText"
    type "MyText"
    start_time "2012-10-26 07:48:43"
    end_time "2012-10-26 07:48:43"
    value1 1.5
    value2 1.5
  end
end
