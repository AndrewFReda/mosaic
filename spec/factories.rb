FactoryGirl.define do
  factory :histogram do
    dominant_hue 1
  end

  factory :picture do
    histogram
    sequence(:name) { |n| "_testpicture#{n}.png" }
    url 'test_url'
    type 'composition'
  end

  factory :user do

    sequence(:email) { |n| "_testemail#{n}@testhost.com" }
    password 'somepassword'
    password_confirmation { password }

    # user_with_pictures will create post data after the user has been created
    factory :user_with_pictures do
      # See FactorGirl documentation: has_many
      transient do
        picture_count 3
      end

      after(:create) do |user, evaluator|
        create_list(:picture, evaluator.picture_count, user: user)
      end
    end
  end
end