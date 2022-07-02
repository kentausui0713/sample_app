class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    # テストを通すため、@userグローバル変数を使用
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user &. authenticate(params[:session][:password])
      if @user.activated?
        login @user
        # if params[:session][:remember_me] == '1'
        #   remember(user)
        # else
        #   foget(user)
        # end
        # 上の処理をif-thenの下の1行で表している
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        #redirect_back_orメソッドはヘルパーメソッドでsessions_helper.rbに記載
        redirect_back_or @user
      else
        message = "Account not actived."
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
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
