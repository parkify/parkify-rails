# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :card do
    customer_id "MyString"
    user_id 1
    active_customer false
    zip_code "MyString"
    last4 "MyString"
  end
end
