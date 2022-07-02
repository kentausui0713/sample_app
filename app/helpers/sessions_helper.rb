module SessionsHelper
  def login(user)
    session[:user_id] = user.id
  end
  
  #ユーザーのセッションを永続的にするため
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  def current_user
    # session[:user_id]があれば
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    #cookies.encrypted[:user_id]で暗号化を解除している
    #Bcryptでのハッシュ化は復元できないが、encryptedの暗号化は復元できる　→暗号化とハッシュ化の違い（不可逆性）
    # session[:user_id]がない場合にcookies.encrypted[:user_id]があれば
    # （ブラウザを一旦閉じた後にブラウザをもう一度開いた時など）
    elsif(user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        login user
        @current_user = user
      end
    end
  end
  
  def current_user?(user)
    user && user == current_user
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  # 永続セッションを破棄するためのヘルパー
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  #sessionsコントローラdestroyアクションに記載している
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  #記憶したURL(もしくはデフォルト値)にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwording_url] || default)
    session.delete(:forwording_url)
  end
  
  # アクセスしようとしたURLを覚える
  def store_location
    session[:forwording_url] = request.original_url if request.get?
  end
  
  
end