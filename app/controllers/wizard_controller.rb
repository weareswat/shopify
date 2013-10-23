class WizardController < ApplicationController
  around_filter :shopify_session, :except => 'welcome'

  def step1
    @menu = "Wizard"
    @shop = Shop.where(:store_url => ShopifyAPI::Shop.current.domain).first
  end

end
