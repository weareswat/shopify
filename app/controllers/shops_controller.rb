class ShopsController < ApplicationController

  around_filter :shopify_session
  
  def update
    @menu="dashboard"
    @shop = Shop.find(params[:id])
     
      
    respond_to do |format|
      if @shop.store_url!=ShopifyAPI::Shop.current.domain
        format.html { redirect_to root_url, notice: 'Not your store mate!'  }
      end
      
      if @shop.update_attributes(params[:shop])
        format.html { redirect_to root_url, notice: 'Shop was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end
  
end
