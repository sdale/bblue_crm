class DealsController < ApplicationController

  before_filter :get_deal, :except => [:index, :new, :create]


  def index
    @users = User.all
    @selected_users = ['everyone']
    filter = params[:filter]
    unless filter.blank?
      @deals = []
      unless filter[:users].blank?
        @selected_users = User.all(:conditions => {:name => filter[:users]}).map{|user|user.email}
        @deals += BatchBook::Deal.find_all_by_param(:assigned_to, @selected_users)
        @selected_users = filter[:users]
      end
      unless filter[:status].blank?
        @status = filter[:status]
        @deals += BatchBook::Deal.find_all_by_param(:status, @status)
      end
      unless filter[:date_from].blank?
        @deals = BatchBook::Deal.find_all_by_tag('dealinfo') do |tag|
          tag.first['fields']['close_date'].to_date >= filter[:date_from].to_date
        end
      end
      unless filter[:date_to].blank?
        @deals = BatchBook::Deal.find_all_by_tag('dealinfo') do |tag|
          tag.first['fields']['close_date'].to_date <= filter[:date_to].to_date
        end
      end
      @deals.uniq!
    else
      @deals = BatchBook::Deal.find(:all)
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
