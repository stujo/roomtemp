# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :current_vote do
    score 1
    room nil
    user nil
  end
end
