class CreateProductIngredients < ActiveRecord::Migration[7.1]
  def change
    create_table :product_ingredients do |t|
      t.references :product, null: false, foreign_key: true, index: false
      t.references :ingredient, null: false, foreign_key: true, index: false
      t.integer :quantity, null: false, unsigned: true

      t.timestamps
    end
    add_index :product_ingredients, [:product_id, :ingredient_id], unique: true
  end
end
