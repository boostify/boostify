if ENV['ORM'] == 'active_record'
  class User < ActiveRecord::Base
    attr_accessible :name
  end
else
  class User
    include Mongoid::Document
    field :name, type: String
  end
end
