FactoryGirl.define do
  factory :histogram do
    dominant_hue 1
  end

  factory :picture do
    histogram
    name 'yoyoyotestpicture.png'
    type 'composition'
  end

  factory :user do
    picture
    sequence(:email) { |n| "testingemailaccount#{n}@testingemailaddress.com" }
    password 'somepassword'
    password_confirmation { password }
  end
end