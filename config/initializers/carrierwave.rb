CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'                        # 使うプロバイダを指定
    config.fog_credentials = {
      provider: 'AWS',                                      # プロバイダとしてAWSを指定
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],          # AWSアクセスキー
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],  # AWSシークレットキー
      region: 'us-west-1'                                   # 使用するリージョン
    }
    config.fog_directory  = ENV['AWS_BUCKET']               # 使用するS3バケット
    config.fog_public     = true                             # 公開設定
end
  