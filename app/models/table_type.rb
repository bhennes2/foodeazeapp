class TableType < ActiveRecord::Base
  attr_accessible :layout_id, :quantity, :size, :turnover, :location, :position
  
  serialize :position, Array
  
  belongs_to :layout
  
end
