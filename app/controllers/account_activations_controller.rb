class AccountActivationsController < ApplicationController
  
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      #テキストではlog_inだが、sessionsヘルパーで定義されてるのはlogin(user)のため修正
      login user
      flash[:success] = "Account actived!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
  
end
