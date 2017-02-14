class InvitationsController < ApplicationController

  def create
    @event = Event.find(params[:invitation][:attended_event_id])
    current_user.attend!(@event)
    redirect_to @event
  end

  def destroy
    @event = Invitation.find(params[:id]).attended_event
    current_user.cancel!(@event)
    redirect_to @event
  end
end
