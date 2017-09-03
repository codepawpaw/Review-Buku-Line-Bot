FactoryGirl.define do
  factory :book do
    title { Faker::Lorem.word }
    id { Faker::Number.number(10) }
    isbn { Faker::Number.word }
  end
end