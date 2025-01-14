require 'googleauth'
require 'googleauth/id_token'

class GoogleOauthService
  def self.get_user_info(id_token)
    # Googleの公開鍵を使ってIDトークンを検証
    begin
      # GoogleのOAuth2公開鍵でトークンを検証
      verifier = Google::Auth::IDTokens::Verifier.new
      payload = verifier.verify(id_token)
      
      # トークンが有効な場合、ユーザー情報を返す
      # payloadにはIDトークンから取得したユーザー情報が含まれる
      {
        email: payload['email'],
        name: payload['name'],
        picture: payload['picture']
      }
    rescue Google::Auth::IDTokens::VerificationError => e
      # トークンが無効な場合はnilやエラーメッセージを返す
      { error: 'Invalid ID Token' }
    end
  end
end
