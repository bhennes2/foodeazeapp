class Food < ActiveRecord::Base
  attr_accessible :content, :post_id
  
  belongs_to :post
  
  #has_one :restaurant, :through => :post
  
end
