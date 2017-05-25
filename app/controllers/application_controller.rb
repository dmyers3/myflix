class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  helper_method :logged_in?, :current_user
  
  def current_user
    @current_user ||= session[:user_id] ? User.find(session[:user_id]) : nil
  end
  
  def logged_in?
    !!current_user
  end
  
  def redirect_logged_out
    if !logged_in?
      flash[:danger] = "Access reserved for members only. Please sign in or register first."
      redirect_to root_path
    end
  end
  
  def logged_in_home_page
    redirect_to home_path if logged_in?
  end
end
