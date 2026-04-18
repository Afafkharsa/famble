class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      @assistant_message = @chat.messages.create(role: "assistant", content: "")

      send_question

      @assistant_message.update(content: @response.content)
      broadcast_replace(@assistant_message)

      @chat.generate_title_from_first_message if @chat.messages.where(role: "user").count == 1

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

  def send_question(model: "gpt-4.1-nano", with: {})
    family = current_user.family
    @ruby_llm_chat = RubyLLM.chat(model: model)

    build_conversation_history

    @ruby_llm_chat
      .with_tool(FamilyMembersTool.new(family: family))
      .with_tool(FamilyTasksTool.new(family: family))
      .with_tool(FamilyRewardsTool.new(family: family))
      .with_tool(FamilyMealPlansTool.new(family: family))
      .with_tool(FamilyCalendarTool.new(family: family))
      .with_instructions(FambleAi::SystemPrompt.new(user: current_user).call)

    @response = @ruby_llm_chat.ask(@message.content, with: with) do |chunk|
      next if chunk.content.blank?

      @assistant_message.content += chunk.content
      broadcast_replace(@assistant_message)
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
