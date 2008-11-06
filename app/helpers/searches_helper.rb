module SearchesHelper
  
  # Return the partial (including path) for the given object.
  # partial can also accept an array of objects (of the same type).
  def partial(object)
    object = object.first if object.is_a?(Array)
    klass = object.class.to_s
    case klass
    when "Topic"
      dir  = "topics" 
      part = "search_result"
    when "AllPerson"
      dir  = 'users'
      part = 'user'
    else
      dir  = klass.tableize  # E.g., 'Person' becomes 'people'
      part = dir.singularize # E.g., 'people' becomes 'person'
    end
    admin_search? ? "admin/#{dir}/#{part}" : "#{dir}/#{part}"
  end

  private
  
    def admin_search?
      params[:model] =~ /Admin/
    end
end
