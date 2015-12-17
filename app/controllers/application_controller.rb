class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  add_breadcrumb "Aid-Interview", :new_user_session_path
  add_breadcrumb "admin", :admin_users_path, :if => :admin_controller?

  def admin_controller?
    self.class.name =~ /^Admin(::|Controller)/
  end
end
