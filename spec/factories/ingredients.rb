FactoryBot.define do
  factory :ingredient do
    name { 'ingredient' }
    initial_stock { 1 }
    available_stock { 1 }
    low_stock_alert_sent { false }
  end
end
