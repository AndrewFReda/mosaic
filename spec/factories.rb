FactoryGirl.define do
  factory :histogram do
    dominant_hue 1
  end

  factory :picture do
    association :histogram
    sequence(:name) { |n| "_testpicture#{n}.png" }
    url 'test_url'
    type 'composition'
  end

  factory :user do
    sequence(:email) { |n| "_testemail#{n}@testhost.com" }
    password 'somepassword'
    password_confirmation { password }

    # user_with_pictures will create picture data after the user has been created
    factory :user_with_pictures do
      transient do
        count_per_picture_type 1
      end

      after(:create) do |user, evaluator|
        evaluator.count_per_picture_type.times do
          create(:picture, type: 'composition', user: user)
          create(:picture, type: 'base', user: user)
          create(:picture, type: 'mosaic', user: user)
        end
      end
    end
  end
end