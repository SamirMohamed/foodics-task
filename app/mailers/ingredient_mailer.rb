class IngredientMailer < ApplicationMailer
  default from: 'notifications@foodics.com'

  def low_stock_alert(ingredient)
    @ingredient = ingredient
    mail(to: 'merchant@example.com', subject: 'Low Stock Alert')
  end
end
