class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user &. authenticate(params[:session][:password])
      login @user
      # if params[:session][:remember_me] == '1'
      #   remember(user)
      # else
      #   foget(user)
      # end
      # 上の処理をif-thenの下の1行で表している
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_to @user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
end
