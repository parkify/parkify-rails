# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :code do
    code_text "MyText"
    personal false
    promo_id 1
  end
end
