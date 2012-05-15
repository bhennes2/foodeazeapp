class Restaurant < ActiveRecord::Base
  attr_accessible :name
  
  has_many :appointments
  has_many :posts
  
  has_many :foods, :through => :posts
  has_many :drinks, :through => :posts
  
  has_many :customers, :through => :appointments
  
  has_one :layout
  has_many :table_types, :through => :layout
  
  def self.create_with_omniauth(auth)
    create! do |restaurant|
      restaurant.twitter_id = auth["uid"]
      restaurant.name = auth["info"]["nickname"]
      restaurant.pic = auth['info']['image']
    end
  end
  
  def has_layout?
    layout = Layout.find_by_restaurant_id(self.id)
    if layout.nil?
      false
    else
      true
    end
  end
  
end
