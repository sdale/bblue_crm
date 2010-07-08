class ContactsController < ApplicationController

  before_filter :get_contact, :except => [:index, :new]

  def index
    @contacts = paginate(BatchBook::Person) | paginate(BatchBook::Company)
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
      BatchBook::Person.new params[:contact]
    else
      BatchBook::Company.new params[:contact]
    end

    if @contact.save
      flash[:notice]  = "#{type.titleize} successfully created!"
      redirect_to :action => :index
    else
      flash.now[ :error ] = @contact.errors.full_messages.join( ", " )
      render "new_#{type}"
    end
  end

  def update
    type = params[:type]
    @contact.attributes = if type == 'person'
      params[:batch_book_person]
    else
      params[:batch_book_company]
    end
    if @contact.save
      flash[:notice]  = "#{type.titleize} successfully updated!"
      redirect_to :action => :index
    else
      flash.now[ :error ] = @contact.errors.full_messages.join( ", " )
      render :edit
    end
  end

  def destroy
    @contact.destroy
    flash[:notice]  = "Contact successfully removed!"
    redirect_to :action => :index
  end
  
  private

  def get_contact
    begin
      @contact = BatchBook::Person.find(params[:id])
    rescue
      begin
        @contact = BatchBook::Company.find(params[:id])
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
