class Customer < ActiveRecord::Base
  attr_accessible :phone, :name
  
  has_many :appointments
  has_many :restaurants, :through => :appointments
  
end
