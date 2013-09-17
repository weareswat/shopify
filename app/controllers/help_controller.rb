class HelpController < ApplicationController
  
  around_filter :shopify_session

end
