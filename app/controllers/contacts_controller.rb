class ContactsController < ApplicationController
  def index
    @contacts = BatchBook::Person.find(:all) |  BatchBook::Company.find(:all)
  end

  def new_person
    @contact = Person.new
  end

  def new_company
    @contact = Company.new
  end

  def show
    begin
      @contact = BatchBook::Person.find(params[:id])
    rescue
      begin
        @contact = BatchBook::Company.find(params[:id])
      rescue
        @contact = nil
      end
    end

    @attributes = @contact.attributes.map{|array| array.first}.delete_if { |value| ['id', 'locations', 'created_at', 'updated_at'].include?(value)  }
    @locations = @contact.locations unless @contact.nil?
  end

  def create_person
    @person = Person.new params[:contact]
    if @person.valid?
      flash[:notice]  = 'Person successfully created!'
      contact = BatchBook::Person.new params[:contact]
      contact.save
      redirect_to :action => :index
    else
      flash.now[ :error ] = @person.errors.full_messages.join( ", " )
      render :new_person
    end
  end
  
   def create_company
    @company = Company.new params[:contact]
    if @company.valid?
      flash[:notice]  = 'Person successfully created!'
      contact = BatchBook::Company.new params[:contact]
      contact.save
      redirect_to :action => :index
    else
      flash.now[ :error ] = @company.errors.full_messages.join( ", " )
      render :new_company
    end
  end


end
