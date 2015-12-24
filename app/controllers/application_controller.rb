class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  add_breadcrumb "Home", :authenticated_root_path

  def admin_controller?
    self.class.name =~ /^Admin(::|Controller)/
  end
end
