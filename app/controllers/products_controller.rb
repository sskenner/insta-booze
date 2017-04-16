# controllers/products_controller.rb

class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def quote
    # code for UberRUSH shipping quote
    ur = Uber::RUSH.new

    pickup_obj = Uber::PICKUP

    dropoff_obj = {
      location: {
        address: params[:address],
        city: params[:city],
        state: "New York",
        postal_code: params[:postal_code],
        country: "US",
      }
    }

    response = ur.delivery_quote(pickup_obj, dropoff_obj)

    respond_to do |format|
      format.html
      format.js do
        @quote = response["quotes"][0]
        @dropoff = dropoff_obj
      end
    end
  end

  def order
    # code for Stripe charge and UberRUSH delivery creation
  end

  def done
    # code for confirmation page
  end
end
