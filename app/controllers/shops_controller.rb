class ShopsController < ApplicationController

  around_filter :shopify_session
  
  def edit
  
  end

  def update
    @menu="dashboard"
    @shop = Shop.find(params[:id])
      
    respond_to do |format|
      if @shop.store_url!=ShopifyAPI::Shop.current.domain
        format.html { redirect_to root_url, notice: 'Not your store mate!'  }
      end
      
      if @shop.update_attributes(params[:shop]) && @shop.invoicexpress_can_connect?
        format.html { redirect_to root_url, notice: 'Shop information was successfully updated.' }
        format.json { head :no_content }
      else
        # format.html { render action: "edit" }
        format.html{ redirect_to setup_path, alert: 'Could not validate information. Please verify API Key and Username is correct.' }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end
  
end
