class AddInitialStockToIngredient < ActiveRecord::Migration[7.1]
  def change
    add_column :ingredients, :initial_stock, :integer, null: false, default: 0, unsigned: true
    rename_column :ingredients, :stock, :available_stock
  end
end
