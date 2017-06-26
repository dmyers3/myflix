class InvitationsController < ApplicationController
  before_action :redirect_logged_out
  
  def new
    @invitation = Invitation.new
  end
  
  def create
    @invitation = Invitation.new(invitation_params.merge!(inviter_id: current_user.id))
    if @invitation.save
      AppMailer.send_invitation_email(@invitation).deliver
      flash[:success] = "Invitation email sent."
      redirect_to new_invitation_path
    else
      flash[:danger] = "Invitation wasn't able to be sent."
      render :new
    end
  end
  
  def invitation_params
    params.require('invitation').permit('recipient_name', 'recipient_email', 'message', 'inviter_id')
  end
end