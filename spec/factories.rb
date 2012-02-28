# encoding: UTF-8

FactoryGirl.define do
  sequence :email do |n|
    "citizen_#{n}@example.com"
  end
  
  factory :citizen do
    email
    password    "salainensana"
    association :profile
  end
  
  factory :profile do
    first_name  "Kimmo"
    last_name   "Kansalainen"
  end
  
  factory :idea do
    title     "Perusidea"
    body      "Hankitaan kaikille kansalaisille ..."
    summary   "Hyvä idea"
    state     "idea"
    association :author, factory: :citizen
  end
end