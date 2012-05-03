class TableType < ActiveRecord::Base
  attr_accessible :layout_id, :quantity, :size, :turnover
  
  belongs_to :layout
  
end
