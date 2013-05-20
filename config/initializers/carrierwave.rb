# config/initializers/carrierwave.rb
CarrierWave.configure do |config|
  config.cache_dir = "#{Rails.root}/tmp/"
  config.storage = :fog
  config.permissions = 0666
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAI576XAU7SH57QZFA',
    :aws_secret_access_key  => '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',
  }
  config.fog_directory  = 'getboardgames'
end