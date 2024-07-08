class Ingredient < ApplicationRecord
  has_many :product_ingredients
  has_many :products, through: :product_ingredients

  validates :name, presence: true
  validates :initial_stock, numericality: { greater_than_or_equal_to: 0 }
  validates :available_stock, numericality: { greater_than_or_equal_to: 0 }

  def self.bulk_update(ingredients)
    import! ingredients, on_duplicate_key_update: [:name, :initial_stock, :available_stock]
  end
end
