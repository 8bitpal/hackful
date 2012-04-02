FactoryGirl.define do
  factory :post do
    title { FactoryGirl.generate :unique_user_name }
    text { Faker::Internet.email }
    link { "http://#{Faker::Internet.domain_name}/#{Faker::Internet.domain_word}" }
  end
end
