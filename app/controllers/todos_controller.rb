class TodosController < ApplicationController

  before_filter :get_todo, :except => [:index, :new, :create]


  def index
    @todo = Todo.cached
  end

  def new
  end

  def show
  end

  def edit
    @todo.due_date = @todo.due_date.to_datetime
  end

  def create
    @todo = Todo.new params[:todo]
    @todo.assigned_by = current_user.name

    if @todo.save
      flash[:notice]  = "Todo successfully created!"
      redirect_to :action => :index
    else
      flash.now[ :error ] = @todo.errors.full_messages.join( ", " )
      render :new
    end
  end

  def update
    @todo.attributes = params[:todo]
    if @todo.save
      flash[:notice]  = "Todo successfully updated!"
      redirect_to :action => :index
    else
      flash.now[ :error ] = @todo.errors.full_messages.join( ", " )
      render :edit
    end
  end

  def destroy
    @todo.destroy
    flash[:notice]  = "Todo successfully removed!"
    redirect_to :action => :index
  end

  protected

  def get_todo
    begin
      @todo = Todo.find(params[:id])
    rescue
      @todo = nil
    end
    unless @todo.nil?
      @attributes = @todo.attributes.map{|array| array.first}.delete_if { |value| ['id', 'tags'].include?(value)  }
    end
  end
  
  
end
