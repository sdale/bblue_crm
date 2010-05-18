class TasksController < ApplicationController

  before_filter :get_task, :except => [:index, :new, :create]


  def index
    @tasks = BatchBook::Todo.find(:all)
  end

  def new
  end

  def show
  end

  def edit
  end

  def create
    @task = BatchBook::Todo.new params[:task]

    if @task.save
      flash[:notice]  = "Task successfully created!"
      redirect_to :action => :index
    else
      flash.now[ :error ] = @task.errors.full_messages.join( ", " )
      render :new
    end
  end

  def update
    @task.attributes = params[:batch_book_todo]
    if @task.save
      flash[:notice]  = "#Task successfully updated!"
      redirect_to :action => :index
    else
      flash.now[ :error ] = @task.errors.full_messages.join( ", " )
      render :edit
    end
  end

  def destroy
    @task.destroy
    flash[:notice]  = "Task successfully removed!"
    redirect_to :action => :index
  end

  protected

  def get_task
    begin
      @task = BatchBook::Todo.find(params[:id])
    rescue
      @task = nil
    end
    unless @task.nil?
      @attributes = @task.attributes.map{|array| array.first}.delete_if { |value| ['id', 'tags'].include?(value)  }
    end
  end
  
  
end
