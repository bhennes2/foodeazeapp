module ApplicationHelper
  
  def sortable(column, title = nil)
    title ||= column.titleize
    # css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "desc") ? "asc" : "desc"
    link_to title << " " << direction, { sort: column, direction: direction } #, { class: css_class }
  end 
end
