class AddLowStockAlertSentToIngredients < ActiveRecord::Migration[7.1]
  def change
    add_column :ingredients, :low_stock_alert_sent, :boolean, default: false
  end
end
