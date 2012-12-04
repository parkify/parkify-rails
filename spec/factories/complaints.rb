# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :complaint do
    user_id 1
    resource_offer_id 1
    image_id 1
    description "MyString"
    latitude 1.5
    longitude 1.5
    resolved false
  end
end
