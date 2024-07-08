class Order < ApplicationRecord
  has_many :order_products
  has_many :products, through: :order_products

  def self.create_with_products(product_id_quantity_map)
    order = Order.create
    order_products = product_id_quantity_map.map do |product_id, quantity|
      { product_id: product_id, order_id: order.id, quantity: quantity }
    end

    OrderProduct.import!(order_products)
  end
end
