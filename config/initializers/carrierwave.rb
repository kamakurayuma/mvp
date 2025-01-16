CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'  # または適切なクラウドストレージプロバイダ
    config.fog_credentials = {
      provider:              'AWS',              # 必要に応じて他のプロバイダ
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region:                'us-east-1',
    }
    config.fog_directory  = ENV['AWS_S3_BUCKET_NAME']
    config.fog_public     = false  # または必要に応じて設定
end
  