if ENV['ORM'] == 'active_record'
  class Transaction < ActiveRecord::Base
    register_currency :eur
    monetize :my_amount_cents
    monetize :my_commission_cents
  end
else
  class Transaction
    include Mongoid::Document

    field :my_amount, type: Money
    field :my_commission, type: Money
  end
end

class Transaction
  include Boostify::Models::Donatable

  donatable_amount :my_amount
  donatable_commission :my_commission
end
