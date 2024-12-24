module UserSessionsHelper
    # ユーザーのセッションを永続的にする
    def remember(user)
        user.remember #Userモデルで定義したrememberメソッド。記憶トークンを作成、ハッシュ化してDBに保存
        cookies.permanent.signed[:user_id] = user.id #ユーザーIDを暗号化してcookieに保存
        cookies.permanent[:remember_token] = user.remember_token #記憶トークンをcookieに保存
    end

    def current_user
        if (user_id = session[:user_id])
          @current_user ||= User.find_by(id: user_id)
        elsif (user_id = cookies.signed[:user_id])
          user = User.find_by(id: user_id)
          if user && user.authenticated?(cookies[:remember_token])
            log_in user
            @current_user = user
          end
        end
      end
    
      # 永続的セッションを破棄する
    def forget(user)
        user.forget #Userクラスのforgetメソッド。DBの記憶ダイジェストにnilを登録。
        cookies.delete(:user_id) #cookieのユーザーIDを削除
        cookies.delete(:remember_token) #cookieの記憶トークンを削除
    end

    # 現在のユーザーをログアウトする
    def log_out
        forget(current_user) #この行を追加
        session.delete(:user_id)
        @current_user = nil
    end
  
  
end
