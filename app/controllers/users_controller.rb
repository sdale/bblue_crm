
class UsersController < ApplicationController
  
  before_filter :get_user, :only => [:show, :edit, :update, :destroy]
  
  def index
    @users = User.all
  end
  
  def show
  end
  
  def edit
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new params[:user]
    if @user.save
      flash[:notice] = 'Registration was successful!'
      redirect_to users_path
    else
      flash.now[:error] = @user.errors.full_messages.join( ", " )
      render :new
    end
  end
  
  def update
    @user.update_attributes params[:user]
    redirect_to :users
  end
  
  def destroy
    @user.destroy
    flash[:notice] = "User successfully deleted."
    redirect_to :users
  end
  
  def login
    if request.post?
      @user = User.authenticate(params[:login], params[:password])
      if @user
        self.current_user = @user
        flash[:notice] = "Login successful!"
        redirect_to root_path
      else
        flash.now[:error] = 'Login unsuccessful'
      end
    end
  end
  
  def logoff
    session[:user_id] = nil
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default
  end
  
  private
  
  def get_user
    @user = User.find(params[:id])
  end

end