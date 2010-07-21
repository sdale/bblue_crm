class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  before_filter :login_required, :except => [:login]
  helper :all
  protect_from_forgery 
  
  def paginate( model )
    load_page
    model.paginate(@page, @per_page)
  end

  def load_page
    @page = params[:page].to_i == 0 ? 1 : params[:page].to_i
    @per_page = params[:per_page].to_i || 10
    if @per_page < 1 || @per_page > 10
      @per_page = 10
    end
  end
end
