# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :flat_rate_price do
    duration 1.5
    price 1.5
    name "MyString"
  end
end
