class ChatsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chats = current_user.chats.where.not(title: "Untitled")
  end

  def create
    @chat = Chat.new(chat_params)

    unless @chat.title
      @chat.title = "Untitled"
    end
    @chat.user = current_user

    if @chat.save
      redirect_to chat_path(@chat)
    else
      redirect_to chats_path
    end
  end

  def show
    @chat = current_user.chats.find(params[:id])
    @chats = current_user.chats.where.not(title: "Untitled").order(created_at: :desc)
    @meal_plan = MealPlan.where(meal: @chat.title).last
    @meal_plans = current_user.family.meal_plans
    @message = Message.new
  end

  def destroy
    @chat = Chat.find(params[:id])
    @chat.destroy
    redirect_to chats_path, notice: "Chat was deleted!", status: :see_other
  end

  private

  def chat_params
    # params.require(:chat).permit(:title)
    permitted = params.require(:chat).permit(:title)
    puts permitted.inspect
    permitted
  end
end
