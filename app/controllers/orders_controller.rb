class OrdersController < ApplicationController
  before_action :order_params, only: [:create]
  def create
  end

  private

  def order_params
    params.require(:products).map do |product|
      product.permit(:id, :quantity)
    end
  end
end
