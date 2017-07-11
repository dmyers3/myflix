class AdminsController < AuthenticatedController
  before_action :ensure_admin
  
  def ensure_admin
    unless current_user.admin?
      flash[:danger] = "You do not have access to this page."
      redirect_to root_path
    end
  end
end