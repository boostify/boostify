class Transaction
  include Mongoid::Document
  include Boostify::Models::Donatable

  field :my_amount, type: Float
  field :my_commission, type: Float

  donatable_amount :my_amount
  donatable_commission :my_commission
end
