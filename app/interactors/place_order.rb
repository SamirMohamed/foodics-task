class PlaceOrder

  include Interactor

  def call
    ActiveRecord::Base.transaction do
      product_id_quantity_map = map_product_id_with_quantity

      product_ids = product_id_quantity_map.keys
      products = products_with_ingredient(product_ids)

      ingredients = update_ingredients(products, product_id_quantity_map)

      Ingredient.bulk_update(ingredients)
      Order.create_with_products(product_id_quantity_map)
    end
  rescue Exception => ex
    context.fail!(error: ex.full_message)
  end

  private

  def map_product_id_with_quantity
    context.order_params[:products].each_with_object({}) do |product, map|
      map[product[:id]] = product[:quantity]
    end
  end

  def products_with_ingredient(product_ids)
    Product.where(id: product_ids).includes(:product_ingredients)
  end

  def update_ingredients(products, product_id_quantity_map)
    ingredients = []

    products.each do |product|
      product.product_ingredients.lock.each do |product_ingredient|
        ingredient = product_ingredient.ingredient
        order_quantity = product_id_quantity_map[product.id]
        ingredient.available_stock -= product_ingredient.quantity * order_quantity
        ingredients << ingredient
      end
    end

    ingredients
  end
end
