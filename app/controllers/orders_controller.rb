class OrdersController < ApplicationController
  before_action :order_params, only: [:create]

  def create
    result = PlaceOrder.call(order_params: order_params)
    if result.success?
      render json: {}, status: :created
    else
      render json: { message: result.error }, status: :unprocessable_entity
    end
  end

  private

  def order_params
    products = params.require(:products).map do |product|
      product.permit(:id, :quantity)
    end

    { products: products }
  end
end
