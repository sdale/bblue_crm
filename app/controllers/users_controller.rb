
class UsersController < ApplicationController
  
  #before_filter :login_required, :except => [:login]
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find params[:id]
  end
  
  def edit
    @user = User.find params[:id]
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new params[:user]
    if @user.save
      self.current_user = @user
      flash[:notice] = 'Registration was successful!'
      redirect_to users_path
    else
      flash.now[:error] = @user.errors.full_messages.join( ", " )
      render :new
    end
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

end