class Post < ActiveRecord::Base
  
  attr_accessible :restaurant_id, :food_id, :drink_id, :image
  
  has_attached_file :image,
          :storage => :s3,
          :s3_credentials => "#{Rails.root}/config/s3.yml",
          :path => "/:style/:id/:filename"
  
  belongs_to :restaurant
  has_many :foods, :dependent => :destroy
  has_many :drinks, :dependent => :destroy
  
  def type
    if self.food_id != nil
      return 'food'
    elsif self.drink_id != nil
      return 'drink'
    elsif self.deal_id != nil
      retrun 'deal'
    elsif self.general_id != nil
      return 'general'
    end
  end
  
end
