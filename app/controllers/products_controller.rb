class ProductsController < ApplicationController
  def index
    @products = Product.all
  end
  
  def show
    @product = Product.find(params[:id])
  end 
  
  def quote 
    # code for UberRUSH shipping quote
  end
  
  def order
    # code for Stripe charge and UberRUSH delivery creation
  end
  
  def done
    # code for confirmation page
  end
end
