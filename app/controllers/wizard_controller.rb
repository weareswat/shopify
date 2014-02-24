class WizardController < ApplicationController
  around_filter :shopify_session, :except => 'welcome'

  def step1
    begin
      @menu = "Wizard"
      @shop  = Shop.where(:store_url=>ShopifyAPI::Shop.current.myshopify_domain).first
      if @shop.nil?
        @shop  = Shop.where(:store_url=>ShopifyAPI::Shop.current.domain).first
      end
    rescue Timeout::Error
      redirect_to trouble_path
    end
  end

end
