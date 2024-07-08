require 'rails_helper'

RSpec.describe "Orders", type: :request do
  describe 'POST /orders' do
    context 'with valid parameters' do
      let(:beef) { create(:ingredient, name: 'Beef', initial_stock: 20000, available_stock: 20000) }
      let(:cheese) { create(:ingredient, name: 'Cheese', initial_stock: 5000, available_stock: 5000) }
      let(:onion) { create(:ingredient, name: 'Onion', initial_stock: 1000, available_stock: 1000) }

      let(:burger) { create(:product, name: 'Burger') }

      let(:valid_params) do
        {
          products: [
            { id: burger.id, quantity: 2 }
          ]
        }
      end

      before do
        create(:product_ingredient, product: burger, ingredient: beef, quantity: 150)
        create(:product_ingredient, product: burger, ingredient: cheese, quantity: 30)
        create(:product_ingredient, product: burger, ingredient: onion, quantity: 20)
      end

      it 'creates an order and updates the stock' do
        post orders_path, params: valid_params, as: :json

        expect(response).to have_http_status(:created)
        expect(beef.reload.available_stock).to eq(19700)
        expect(cheese.reload.available_stock).to eq(4940)
        expect(onion.reload.available_stock).to eq(960)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          invalid_key: []
        }
      end

      it 'returns bad request' do
        post orders_path, params: invalid_params, as: :json

        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'with store do not have enough stock' do
      let(:beef) { create(:ingredient, name: 'Beef', initial_stock: 200, available_stock: 200) }
      let(:cheese) { create(:ingredient, name: 'Cheese', initial_stock: 50, available_stock: 50) }
      let(:onion) { create(:ingredient, name: 'Onion', initial_stock: 10, available_stock: 10) }

      let(:burger) { create(:product, name: 'Burger') }

      before do
        create(:product_ingredient, product: burger, ingredient: beef, quantity: 150)
        create(:product_ingredient, product: burger, ingredient: cheese, quantity: 30)
        create(:product_ingredient, product: burger, ingredient: onion, quantity: 20)
      end

      let(:params) do
        {
          products: [
            { id: burger.id, quantity: 2 }
          ]
        }
      end

      it 'can not place the order' do
        post orders_path, params: params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with available stock level reached 50% or blew' do
      let(:beef) { create(:ingredient, name: 'Beef', initial_stock: 200, available_stock: 200) }

      let(:burger) { create(:product, name: 'Burger') }

      before do
        create(:product_ingredient, product: burger, ingredient: beef, quantity: 50)
      end

      let(:params) do
        {
          products: [
            { id: burger.id, quantity: 2 }
          ]
        }
      end

      it 'sends low level stock email' do
        allow(IngredientMailer).to receive_message_chain(:low_stock_alert, :deliver_now)

        post orders_path, params: params, as: :json

        expect(beef.reload.low_stock_alert_sent).to be_truthy
        expect(IngredientMailer).to have_received(:low_stock_alert).once
      end
    end

    context 'with available stock level reached 50% or blew and already mail sent' do
      let(:beef) { create(:ingredient, name: 'Beef', initial_stock: 100, available_stock: 70, low_stock_alert_sent: true) }

      let(:burger) { create(:product, name: 'Burger') }

      before do
        create(:product_ingredient, product: burger, ingredient: beef, quantity: 50)
      end

      let(:params) do
        {
          products: [
            { id: burger.id, quantity: 1 }
          ]
        }
      end

      it 'do not sends low level stock email' do
        allow(IngredientMailer).to receive_message_chain(:low_stock_alert, :deliver_now)

        post orders_path, params: params, as: :json

        expect(IngredientMailer).not_to have_received(:low_stock_alert)
      end
    end
  end
end
