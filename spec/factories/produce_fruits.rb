# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :produce_fruit, :class => 'Produce::Fruit' do
    kind "MyString"
    variety "MyString"
    quantity 1
  end
end
