# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  #before_filter :login_required, :except => [:users]
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  BatchBook.account = 'ucdev'
  BatchBook.token = 'IzYgSsNtaB'
  BatchBook.per_page = 1000000

end
