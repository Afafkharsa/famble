class MessagesController < ApplicationController
  before_action :authenticate_user!

  SYSTEM_PROMPT = <<~PROMPT
    You are a recipe assistant, helping users find and create recipes.

    I am a user looking to discover new recipes, get cooking instructions and track my calories.

    Help me find, suggest and create recipes. Always structure your recipe with:
    - Name
    - Ingredients with quantities
    - Step by step method
    - Total calories
    - Allergens

    Always respond strictly in JSON without any extra text or markdown.
    The JSON must include these keys:

    {
      "name": string,
      "ingredients": [
        {"ingredient": string, "quantity": string}
      ],
      "method": [string],
      "keywords": [string],
      "calories": integer,
      "allergens": [string]
    }

    Rules:

    1. Never include markdown fences (```), explanations, or any text outside the JSON.
    2. Use arrays for ingredients and method.
    3. Always include all keys even if some values are empty (e.g., "allergens": []).
    4. Make keywords relevant to the recipe.
    5. Ensure ingredient quantities are included.
    6. Always return **valid JSON** ready to parse.

    Example output:

    {
      "name": "High-Protein Greek Yogurt Chicken Salad",
      "ingredients": [
        {"ingredient": "cooked chicken breast", "quantity": "150 g"},
        {"ingredient": "plain Greek yogurt", "quantity": "120 g"},
        {"ingredient": "celery", "quantity": "50 g"}
      ],
      "method": [
        "Mix the chicken with Greek yogurt and celery.",
        "Season with salt and pepper."
      ],
      "keywords": ["high protein", "low carb", "quick meal"],
      "calories": 310,
      "allergens": ["dairy"]
    }

    Be concise, structured, and precise.
  PROMPT

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @meal_plans = current_user.meal_plans

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      @assistant_message = @chat.messages.create(role: "assistant", content: "")

      send_question

      @assistant_message.update(content: @response.content)
      broadcast_replace(@assistant_message)

      if @chat.messages.where(role: "user").count == 1
        @chat.generate_title_from_first_message
      end

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_path(@chat) }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_message_container", partial: "messages/form", locals: { chat: @chat, message: @message }) }
        format.html { render "chats/show", status: :unprocessable_entity }
      end
    end
  end

  private

  def build_conversation_history
    @chat.messages.each do |message|
      next if message.content.blank?

      @ruby_llm_chat.add_message(role: message.role, content: message.content)
    end
  end

  def broadcast_replace(message)
    Turbo::StreamsChannel.broadcast_replace_to(
      @chat,
      target: helpers.dom_id(message),
      partial: "messages/message",
      locals: { message: message }
    )
  end

  def send_question(model: "gpt-4o", with: {})
    @ruby_llm_chat = RubyLLM.chat(model: model)

    build_conversation_history

    @response = @ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content, with: with) do |chunk|
      next if chunk.content.blank?

      @assistant_message.content += chunk.content
      broadcast_replace(@assistant_message)
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
