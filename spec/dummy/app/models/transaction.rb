if ENV['ORM'] == 'active_record'
  class Transaction < ActiveRecord::Base; end
else
  class Transaction
    include Mongoid::Document

    field :my_amount, type: Float
    field :my_commission, type: Float
  end
end

class Transaction
  include Boostify::Models::Donatable

  donatable_amount :my_amount
  donatable_commission :my_commission

  attr_accessible :my_amount, :my_commission
end
