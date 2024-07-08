class Ingredient < ApplicationRecord
  has_many :product_ingredients
  has_many :products, through: :product_ingredients

  validates :name, presence: true
  validates :initial_stock, numericality: { greater_than_or_equal_to: 0 }
  validates :available_stock, numericality: { greater_than_or_equal_to: 0 }

  def self.bulk_update(ingredients)
    import! ingredients, on_duplicate_key_update: [:name, :initial_stock, :available_stock]
    ingredients.each do |ingredient|
      ingredient.check_available_stock_level
    end
  end

  def check_available_stock_level
    if !low_stock_alert_sent && available_stock.to_f <= initial_stock * 0.5
      IngredientMailer.low_stock_alert(self).deliver_now
      self.update(low_stock_alert_sent: true)
    end
  end
end
