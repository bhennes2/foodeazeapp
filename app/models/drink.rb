class Drink < ActiveRecord::Base
  attr_accessible :content, :post_id
  
  belongs_to :post
  
  validates :content, :presence => true
  
  #has_one :restaurant, :through => :post
end
