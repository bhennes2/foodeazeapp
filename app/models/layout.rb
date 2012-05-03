class Layout < ActiveRecord::Base
  attr_accessible :restaurant_id
  
  belongs_to :restaurant
  has_many :table_types, :dependent => :destroy
  
end
