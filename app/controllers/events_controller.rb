class EventsController < ApplicationController
  def index
    @events = policy_scope(Event).order(start_time: :asc)
  end

  def new
     @event = Event.new
    authorize @event
    @family_members = current_user.family.users.order(:name)
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    @event.participant_ids |= [current_user.id]
    if @event.save
      redirect_to events_path, notice: "Event created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @event = Event.find(params[:id])
  authorize @event
  @family_members = current_user.family.users.order(:name)

  end

  def update
    @event = Event.find(params[:id])
    authorize @event
    if @event.update(event_params)
      redirect_to events_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event = Event.find(params[:id])
    authorize @event
    @event.destroy
    redirect_to events_path, status: :see_other
  end

  private

  def event_params
    params.require(:event).permit(:title, :start_time)
  end
end
