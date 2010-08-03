class DealsController < ApplicationController
  include ReportsControllerHelper
  include DealsControllerHelper

  before_filter :get_deal, :except => [:index, :new, :create]

  def index
    @users = User.all
    @people = Person.all
    filter = params[:filter]
    @selected_users = selected_users(filter)
    unless filter.blank? || filter.values.delete_if{|v|v.blank?}.empty?
      @deals = final_report(filter)
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
