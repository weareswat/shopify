class WizardController < ApplicationController
  around_filter :shopify_session, :except => 'welcome'

  def step1
    begin
      @menu = "Wizard"
      @shop = Shop.where(:store_url => ShopifyAPI::Shop.current.domain).first
    rescue Timeout::Error
      redirect_to trouble_path
    end
  end

end
