FactoryBot.define do
  factory :product_ingredient do
    product
    ingredient
    quantity { 1 }
  end
end
