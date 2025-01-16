CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'                        # 必須
    config.fog_credentials = {
      provider:              'AWS',                       # 必須
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],    # Herokuの環境変数に設定
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],# Herokuの環境変数に設定
      region:                ENV['AWS_REGION'],           # AWSのリージョンを指定
    }
    config.fog_directory  = ENV['AWS_BUCKET']             # S3バケット名
    config.fog_public     = true                          # 公開/非公開の設定
end
  