FactoryBot.define do
  factory :user do
    phone { generate :user_phone }
    nickname {'User'}
    avatar_url {'https://example.com/avatar.png'}
  end
end
