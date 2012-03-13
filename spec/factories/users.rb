FactoryGirl.define do
  sequence :unique_user_name do |n|
    Faker::Internet.user_name.delete('^a-zA-Z') + "#{n}"
  end
  factory :user do
    name { FactoryGirl.generate :unique_user_name }
    email { Faker::Internet.email }
    password "testing"
    password_confirmation "testing"
  end
end
