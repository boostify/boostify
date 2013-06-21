module Boostify

  if Boostify.orm == :active_record
    class Charity < ActiveRecord::Base; end
  end

  class Charity
    include Boostify::Models::Mongoid::Charity if Boostify.orm == :mongoid
  end
end
