FactoryGirl.define do
  factory :user do
    email "test@test.com"
    password "password"

    factory :admin_user do
      admin true
    end
  end
end
