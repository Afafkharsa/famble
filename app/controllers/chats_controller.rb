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
    @meal_plan = MealPlan.where(meal: @chat.title).last
    @meal_plans = current_user.meal_plans
    @message = Message.new
  end

  def chat_params
    # params.require(:chat).permit(:title)
    permitted = params.require(:chat).permit(:title)
    puts permitted.inspect
    permitted
  end
end
