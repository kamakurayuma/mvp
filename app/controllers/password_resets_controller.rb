class PasswordResetsController < ApplicationController
    skip_before_action :require_login
  
    def new; end
  
    def create
      @user = User.find_by(email: params[:email])
      @user&.deliver_reset_password_instructions!
      # 「存在しないメールアドレスです」という旨の文言を表示すると、逆に存在するメールアドレスを特定されてしまうため、
      # あえて成功時のメッセージを送信させている
      redirect_to login_path, success: "パスワード再設定用のメールを送信しました"
    end
  
    def edit
      @token = params[:id]
      @user = User.load_from_reset_password_token(@token)
      not_authenticated if @user.blank?
    end
  
    def update
      @token = params[:id]
      @user = User.load_from_reset_password_token(@token)
  
      return not_authenticated if @user.blank?
  
      @user.password_confirmation = params[:user][:password_confirmation]
      if @user.change_password(params[:user][:password])
        redirect_to login_path, success: "パスワードを変更しました"
      else
        flash.now[:danger] = "パスワードの変更に失敗しました"
        render :edit, status: :unprocessable_entity
      end
    end
  end