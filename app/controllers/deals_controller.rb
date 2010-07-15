class DealsController < ApplicationController
  include ReportsControllerHelper

  before_filter :get_deal, :except => [:index, :new, :create]

  def index
    @users = User.all
    @people = BatchBook::Person.cached
    @selected_users = ['everyone']
    filter = params[:filter]
    unless filter.blank? || filter.values.delete_if{|v|v.blank?}.empty?
      @deals = []
      unless filter[:users].blank?
        @selected_users = User.all(:conditions => {:name => filter[:users]}).map{|user|user.name} #map to user.email case you're not using cached information!
        @deals += BatchBook::Deal.find_all_by_param(:assigned_to, @selected_users)
        @selected_users = filter[:users]
      end
      unless filter[:status].blank?
        @status = filter[:status]
        @deals += BatchBook::Deal.find_all_by_param(:status, @status)
      end
      unless filter[:date_from].blank?
        @deals += BatchBook::Deal.find_all_by_supertag('dealinfo') do |tag|
          tag.first['fields']['close_date'].to_date >= filter[:date_from].to_date
        end
      end
      unless filter[:date_to].blank?
        @deals += BatchBook::Deal.find_all_by_supertag('dealinfo') do |tag|
          tag.first['fields']['close_date'].to_date <= filter[:date_to].to_date
        end
      end
      @deals.uniq!
    else
      @deals = BatchBook::Deal.cached('eager')
    end
    respond_to do |format|
      format.html
      format.xls{ render_xls( @deals, BatchBook::Deal ) }
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
    [:title, :description, :due_date, :assigned_to, :assigned_by].each do |attr|
      task_params[attr] = params[:deal][attr]
    end
    @deal = BatchBook::Deal.new deal_params
    @task = BatchBook::Todo.new task_params

    if @deal.save && @task.save
      flash[:notice]  = "Deal successfully created!"
      redirect_to :action => :index
    else
      flash.now[ :error ] = @deal.errors.full_messages.join( ", " ) + @task.errors.full_messages.join( ", " )
      render :new
    end
  end

  def update
    @deal.attributes = params[:batch_book_deal]
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
      @deal = BatchBook::Deal.find(params[:id])
    rescue
      @deal = nil
    end
    unless @deal.nil?
      @attributes = @deal.attributes.map{|array| array.first}.delete_if { |value| ['id', 'tags'].include?(value)  }
    end
  end
  
  
end
