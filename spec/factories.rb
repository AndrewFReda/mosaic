FactoryGirl.define do
  factory :user do
    email    'testingemailaccount@testingemailaddress.com'
    password 'somepassword'
  end

  factory :picture do
    name 'yoyoyotestpicture.png'
    type 'composition'
    user_id 1
  end
end