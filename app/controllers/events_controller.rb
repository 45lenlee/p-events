class EventsController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update, :destroy]
  before_action :correct_user, only: :destroy

  def index
    @events = Event.all
  end

  def new
    @event = current_user.events.build
  end

  def create
    @event = current_user.events.build(events_params)
    if @event.save
      flash[:success] = "Event created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def edit

  end

  def update

  end

  def destroy
    @event.destroy
    flash[:success] = 'Event deleted'
    redirect_to request.referrer || root_url
  end

  private
    def events_params
      params.require(:event).permit(:title, :location, :description, :date)
    end

    def correct_user
      @event = current_user.events.find_by(id: params[:id])
      redirect_to root_url if @event.nil?
    end
end
