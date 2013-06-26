Boostify.config do |config|
  config.partner_id = 1234
  config.partner_secret = 'wohoo_tschaka'

  config.orm = if ENV['ORM'] == 'active_record'
                 :active_record
               else
                 :mongoid
               end
end
