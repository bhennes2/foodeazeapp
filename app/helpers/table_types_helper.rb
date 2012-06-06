module TableTypesHelper
  
  def update_layout_and_save(positions, table_types)
    table_types.each do |table|
      a = Array.new
      positions.each do |key, value|
        if table.size == value['size'].to_i
          a.push({ id: value['id'], top: value['top'], left: value['left'] })
        end
      end
      table.update_attributes(position: a)
    end    
  end
  
end
