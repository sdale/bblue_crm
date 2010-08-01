class DealsController < ApplicationController
  include ReportsControllerHelper

  before_filter :get_deal, :except => [:index, :new, :create]

  def index
    @users = User.all
    @people = Person.all
    @selected_users = ['everyone']
    filter = params[:filter]
    unless filter.blank? || filter.values.delete_if{|v|v.blank?}.empty?
      @deals = []
      unless filter[:users].blank?
        if Deal.caching?
          @selected_users = User.all(:conditions => {:name => filter[:users]}).map{|user|user.name} 
        else
          @selected_users = User.all(:conditions => {:name => filter[:users]}).map{|user|user.email}
        end
        @deals += Deal.find_all_by_param(:assigned_to, @selected_users)
        @selected_users = filter[:users]
      end
      unless filter[:status].blank?
        @status = filter[:status]
        @deals += Deal.find_all_by_param(:status, @status)
      end
      unless filter[:date_from].blank?
        begin
          @deals += Deal.find_all_by_supertag('dealinfo') do |tag|
            tag.first['fields']['close_date'].to_date >= filter[:date_from].to_date
          end
        rescue
          flash[:warning] = 'Date filter is unavailable!'
        end
      end
      unless filter[:date_to].blank?
        begin
          @deals += Deal.find_all_by_supertag('dealinfo') do |tag|
            tag.first['fields']['close_date'].to_date <= filter[:date_to].to_date
          end
          @deals = Deal.all
        rescue
          flash[:warning] = 'Date filter is unavailable!'
          @deals = Deal.all 
        end
      end
      @deals.uniq!
    else
      @deals = Deal.all
    end
    respond_to do |format|
      format.html
      format.xls{ render_xls( @deals, Deal ) }
    end
  end

  def new
  end

  def show
  end

  def edit
  end

  def create
    deal_params, task_params = {},{}
    [:title, :description,:amount, :status, :assigned_to, :deal_with].each do |attr|
      deal_params[attr] = params[:deal][attr]
    end
    [:title, :description, :due_date, :assigned_to].each do |attr|
      task_params[attr] = params[:deal][attr]
    end
    @deal = Deal.new deal_params
    @todo = Todo.new task_params
    
    @todo.assigned_by = current_user.name

    if @deal.save && @todo.save
      flash[:notice]  = "Deal successfully created!"
      redirect_to :action => :index
    else
      flash.now[ :error ] = @deal.errors.full_messages.join( ", " ) + @todo.errors.full_messages.join( ", " )
      render :new
    end
  end

  def update
    @deal.attributes = params[:deal]
    if @deal.save
      flash[:notice]  = "Deal successfully updated!"
      redirect_to :action => :index
    else
      flash.now[ :error ] = @deal.errors.full_messages.join( ", " )
      render :edit
    end
  end

  def destroy
    @deal.destroy
    flash[:notice]  = "Deal successfully removed!"
    redirect_to :action => :index
  end

  protected

  def get_deal
    begin
      @deal = Deal.find(params[:id])
    rescue
      @deal = nil
    end
    unless @deal.nil?
      @attributes = @deal.attributes.map{|array| array.first}.delete_if { |value| ['id', 'tags'].include?(value)  }
    end
  end
  
  
end
