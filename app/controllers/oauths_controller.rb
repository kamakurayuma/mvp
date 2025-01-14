class OauthsController < ApplicationController
  skip_before_action :require_login
  skip_before_action :verify_authenticity_token, only: [:oauth]

  # Google OAuth2 認証フロー
  def oauth
    # IDトークンを取得
    token = params[:oauth][:id_token]
  
    # ユーザーを認証
    user = User.from_omniauth(token)
  
    # ユーザーがnilでないかを確認
    if user && user.persisted?
      # ログインしてユーザーをセッションに保存
      session[:user_id] = user.id
      Rails.logger.debug("Session User ID: #{session[:user_id]}") # デバッグメッセージを追加
  
      # JSONレスポンスを返す（フラッシュメッセージを含まない）
      render json: { success: true, message: "Googleアカウントでログインしました", redirect_url: root_path }, status: :ok
    else
      # ユーザー作成失敗した場合の処理
      render json: { success: false, message: "ログインに失敗しました", redirect_url: root_path }, status: :unprocessable_entity
    end
  end
  

  # OAuth コールバック処理
  def callback
    Rails.logger.debug("Callback params: #{params.inspect}") # デバッグ追加
    code = params[:code] # 認証コードを取得

    if code.nil?
      redirect_to root_path, alert: "認証コードが指定されていません"
      return
    end

    begin
      # 認証コードを使ってアクセストークンを取得
      tokens = get_google_tokens(code)
      access_token = tokens[:access_token]
      id_token = tokens[:id_token]

      # アクセストークンを使ってGoogleユーザー情報を取得
      user_info = get_google_user_info(access_token)

      # ユーザーが存在するか確認してログイン
      @user = User.find_or_create_by(email: user_info[:email]) do |user|
        user.name = user_info[:name]
      end

      # ログイン処理
      reset_session
      auto_login(@user)
      redirect_to profile_path, notice: "Googleアカウントでログインしました" # プロフィールページにリダイレクト
    rescue => e
      Rails.logger.error("OAuth callback error: #{e.message}")
      redirect_to root_path, alert: "Google認証に失敗しました"
    end
  end

  private

  # Google OAuthトークンの取得
  def get_google_tokens(code)
    response = RestClient.post("https://oauth2.googleapis.com/token", {
      code: code,
      client_id: Rails.application.credentials.dig(:google, :google_client_id),
      client_secret: Rails.application.credentials.dig(:google, :google_client_secret),
      redirect_uri: url_for(controller: 'oauths', action: 'callback', only_path: false),
      grant_type: 'authorization_code'
    })
    JSON.parse(response.body).symbolize_keys
  end

  # Google ユーザー情報の取得
  def get_google_user_info(access_token)
    response = RestClient.get("https://www.googleapis.com/oauth2/v1/userinfo", {
      params: { access_token: access_token }
    })
    JSON.parse(response.body).symbolize_keys
  end

  # 認証パラメータの許可
  def auth_params
    params.permit(:id_token, :provider, :scope, :authuser, :prompt, :code)
  end
end
