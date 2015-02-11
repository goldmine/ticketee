FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@test.com" }
  factory :user do
    password "password"
    email { generate(:email) }
    factory :admin_user do
      admin true
    end
  end
end
