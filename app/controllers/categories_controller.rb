class CategoriesController < ApplicationController
  before_action :redirect_logged_out
  
  def show
    @category = Category.find(params[:id])
  end
end