class ApplicationController < ActionController::Base
  include SessionsHelper
  
  private
  # ログイン済みユーザーか確認
  def logged_in_user
      # logged_in?メソッドはsessions_helperから継承されている
      # helpers内の全メソッドは全コントローラで呼び出し可能(Railsのデフォルトでincludeされているため)
      unless logged_in?
        store_location
        flash[:danger] = "Please log in"
        redirect_to login_url
      end
  end
end
