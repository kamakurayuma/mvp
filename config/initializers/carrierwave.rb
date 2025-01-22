CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'  # S3を使うための指定
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'], # Herokuの環境変数で設定されているか
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'], # Herokuの環境変数で設定されているか
      region: ENV['AWS_REGION'], # 必要に応じて設定
    }
    config.fog_directory = ENV['AWS_BUCKET']  
    config.fog_public = true  
  end
  