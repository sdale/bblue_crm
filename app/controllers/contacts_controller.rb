class ContactsController < ApplicationController

  before_filter :get_contact, :except => [:index, :new]

  def index
    @contacts = Person.find(:all) | Company.find(:all)
    @contacts.sort! { |x, y| x.attributes['id'] <=> y.attributes['id']  }
  end

  def new
    @type = params[:type]
  end

  def show
  end

  def edit
  end

  def create
    type = params[:type]
    @contact = if type == 'person'
      Person.new params[:contact]
    else
      Company.new params[:contact]
    end

    if @contact.save
      flash[:notice]  = "#{type.titleize} successfully created!"
      redirect_to :action => :index
    else
      @type = type
      flash.now[ :error ] = @contact.errors.full_messages.join( ", " )
      render :new
    end
  end

  def update
    type = params[:type]
    @contact.attributes = if type == 'person'
      params[:person]
    else
      params[:company]
    end
    if @contact.save
      flash[:notice]  = "#{type.titleize} successfully updated!"
      redirect_to :action => :index
    else
      flash.now[ :error ] = @contact.errors.full_messages.join( ", " )
      render :edit
    end
  end
  
  def convert
    begin
      @contact.add_supertag 'ownership', :owner => current_user.name
      @contact.remove_tag 'lead'
      @contact.add_tag 'customer'
      todo = Todo.new  :title => "Follow up with #{@contact.name}", 
                                  :description => "Task created from a conversion from lead -> customer",
                                  :due_date => 2.months.from_now,
                                  :assigned_to => current_user.name,
                                  :assigned_by => current_user.name
      todo.save
      flash[:notice] = "#{@contact.name} was successfully converted from lead to customer!!"
    rescue
      flash[:error] = "Unable to convert #{@contact.name}"
    end
    redirect_to :action => :index
  end

  def destroy
    @contact.destroy
    flash[:notice]  = "Contact successfully deleted!"
    redirect_to :action => :index
  end
  
  private

  def get_contact
    begin
      @contact = Person.find(params[:id])
    rescue
      begin
        @contact = Company.find(params[:id])
      rescue
        @contact = nil
      end
    end
    unless @contact.nil?
      @attributes = @contact.attributes.map{|array| array.first}.delete_if { |value| ['id', 'locations', 'tags', 'created_at', 'updated_at'].include?(value)  }
      @locations = @contact.locations
    end
  end
  
end
