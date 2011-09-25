class LoginController < ApplicationController

  def login
  end

  def authenticate
    @user = User.authenticate(params[:user][:username], params[:user][:password])
    respond_to do |format|
      if @user
        session[:user_id] = @user.id
        format.html { redirect_to('/', notice: 'Login successful!') }
        format.json { render json: @user, status: 'Success' }
      else
        session[:user_id] = nil
        format.html { redirect_to('/login/login', notice: 'Login failed!') }
        format.json { render json: nil, status: 'Failed' }
      end
    end
  end

  def register
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @user.encrypt_password
    respond_to do |format|
      if @user.save
        UserMailer.welcome_email(@user).deliver
        format.html { redirect_to('/login/login', notice: 'User has been created! Please wait for your validation email to arrive before logging in.')}
        format.json { render json: @user, status: 'Success' }
      else
        format.html { render action: 'register'}
        format.json { render json: @user, status: 'Failed', messages: @user.errors }
      end
    end
  end

  def validate
    @user = User.find(params[:id])
    respond_to do |format|
      if @user && @user.validation_token == params[:token]
        @user.validated_at = Time.now
        @user.save
        format.html { redirect_to('/login/login', notice: 'Your validation has been processed. Please log in.')}
        format.json { render json: @user, status: 'Success' }
      else
        format.html { redirect_to('/login/login', notice: 'The validation address was not correct. Please check your email and try again.') }
        format.json { render json: @user, status: 'Failed' }
      end
    end
  end

  def logout
    session[:user_id] = nil
    respond_to do |format|
      format.html { redirect_to('/login/login', notice: 'You have logged out.') }
      format.json { render json: nil, status: 'Success' }
    end
  end
end
