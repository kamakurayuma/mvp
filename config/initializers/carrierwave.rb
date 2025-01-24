require 'carrierwave/cloudinary'

CarrierWave.configure do |config|
  config.cloudinary = Cloudinary::CarrierWave
end