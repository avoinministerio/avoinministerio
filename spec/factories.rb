# encoding: UTF-8

FactoryGirl.define do
  sequence :email do |n|
    "citizen_#{n}@example.com"
  end

  factory :profile do |p|
    first_name 'Erkki'
    last_name 'Esimerkki'
  end

  factory :citizen do
    email
    password    "salainensana"
    association :profile
  end

  factory :erkki, :parent => :citizen do |e|
    email 'erkki@esimerkki.fi'
    first_name 'Erkki'
    last_name 'Esimerkki'
    password 'sekretPa$$word'
    association :profile, factory: :profile
  end

  factory :authentication do |a|
    provider 'facebook'
    uid '1234567'
  end

  factory :facebookin_erkki, parent: :erkki do |e|
    after_create do |erkki|
      Factory.create(:authentication, citizen: erkki)
    end
  end
  
  factory :idea do
    title     "Idea uudesta laista"
    body      "Hankitaan kaikille kansalaisille ..."
    summary   "Hyvä idea"
    state     "idea"
    association :author, factory: :citizen
  end

  factory :vote do
    option 1
    association :idea, factory: :idea
    association :citizen, factory: :citizen
  end

  factory :comment do
    body      "Tongue pancetta ball tip, t-bone short loin shankle short ribs ribeye. Salami turducken pork, venison jowl fatback pork loin pancetta hamburger."
    association :author, factory: :citizen
    association :commentable, factory: :idea
  end

  sequence :title do |n|
    "Title #{n}"
  end

  factory :article do
    article_type  'statement'
    title
    ingress       'Article ingress'
    body          'Article body'
    association :idea, factory: :idea
    association :author, factory: :citizen
    publish_state 'published'
  end
end
