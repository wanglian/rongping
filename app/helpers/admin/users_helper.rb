module Admin::UsersHelper
  
  def user_type(user)
    if user.has_role?('admin')
      'admin'
    elsif user.has_role?('admin')
      'customer'
    else
      'user'
    end
  end
  
end
