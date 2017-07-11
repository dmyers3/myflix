class AuthenticatedController < ApplicationController
  before_action :redirect_logged_out
end