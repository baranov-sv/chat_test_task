FactoryBot.define do
  sequence :user_phone do |n|
    "+7-XXX-XXXX-XX-X#{n}"
  end
end