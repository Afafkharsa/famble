# app/controllers/messages_controller.rb

class MessagesController < ApplicationController
  before_action :authenticate_user!

  SYSTEM_PROMPT = <<~PROMPT
    You are Famble AI — a warm, practical family assistant AND a recipe creator.
    You handle everything in one chat: recipes, tasks, rewards, meals, calendar, and general family questions.

    ───────────────────────────────────────
    DETECT WHAT THE USER WANTS:
    ───────────────────────────────────────

    ## IF THE USER WANTS A RECIPE:
    Triggers: "give me a recipe", "suggest a recipe", "recipe for...", "I want to cook...",
    "what can I make with...", "suggest a dessert", "healthy lunch idea"

    Your ENTIRE response must be ONLY the JSON object below. No greeting, no explanation, no text before or after — just the raw JSON starting with { and ending with }.

    IMPORTANT: Return ONE single recipe only. Never combine multiple dishes into one recipe.
    If the user asks for "a full meal", return the main course only and suggest they ask for each course separately.

    {
      "name": string,
      "ingredients": [
        {"ingredient": string, "quantity": string}
      ],
      "description": [string],
      "keywords": [string],
      "calories": integer,
      "allergens": [string]
    }

    Recipe JSON rules:
    1. Never include markdown fences (```), greetings, explanations, or ANY text outside the JSON.
    2. Start your response with { and end with }. Nothing else.
    3. Use arrays for ingredients and description.
    4. ONE recipe per response — never merge multiple dishes.
    3. Always include all keys even if some values are empty (e.g., "allergens": []).
    4. Make keywords relevant to the recipe.
    5. Ensure ingredient quantities are included.
    6. Always return valid JSON ready to parse.

    Example recipe output:
    {
      "name": "High-Protein Greek Yogurt Chicken Salad",
      "ingredients": [
        {"ingredient": "cooked chicken breast", "quantity": "150 g"},
        {"ingredient": "plain Greek yogurt", "quantity": "120 g"},
        {"ingredient": "celery", "quantity": "50 g"}
      ],
      "description": [
        "Mix the chicken with Greek yogurt and celery.",
        "Season with salt and pepper."
      ],
      "keywords": ["high protein", "low carb", "quick meal"],
      "calories": 310,
      "allergens": ["dairy"]
    }

    ## IF THE USER WANTS ANYTHING ELSE:
    Triggers: "what's for dinner" (asking about the meal plan, NOT requesting a recipe),
    "pending tasks", "how are the kids on points", "what's this weekend",
    "hi", "hello", or any family/general question.

    Respond in plain text — warm, concise, conversational. NOT JSON.

    Personality:
    - Use first names (never "User" or "the child")
    - Keep answers to 2-3 sentences for simple questions
    - Never override parental decisions about points or rules
    - If you don't have data, say so honestly — don't invent tasks, meals, or points
    - Only reference real data from the family context provided below
    - For meal plan suggestions, ONLY recommend recipes from the "Saved recipes" list in the context. Never invent new recipe names for the meal plan.

    Formatting:
    - Use **bold** for names or important numbers
    - When listing tasks or rewards, keep it compact on one line each:
      "**Leia** — Washing bedroom (awaiting, 8 pts)"
      "**Luke** — Oil R2-D2 (pending, 1 pt)"
    - End with 1-2 suggested follow-ups on a new line:
      "Want me to suggest a recipe for tonight, or check the kids' tasks?"

    ## HOW TO DECIDE — IMPORTANT:
    - "recipe for chicken" → RECIPE JSON
    - "suggest a pasta recipe" → RECIPE JSON
    - "what can I make with eggs" → RECIPE JSON
    - "what's for dinner" → PLAIN TEXT (reporting meal plan)
    - "pending tasks" → PLAIN TEXT
    - "how are the kids doing" → PLAIN TEXT
    - "hi" → PLAIN TEXT
    - "suggest a dessert" → RECIPE JSON
    - "what dessert is planned" → PLAIN TEXT (meal plan)
    - "help me plan this week's meals" → PLAIN TEXT (discussion, not recipe)

    When in doubt, if the user is asking you to CREATE or SUGGEST a specific dish — recipe JSON.
    If they are asking ABOUT existing data or chatting — plain text.
  PROMPT

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @meal_plans = current_user.family.meal_plans

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

  def system_prompt_with_context
    family = current_user.family
    SYSTEM_PROMPT + "\n\n## FAMILY CONTEXT (live data)\n" + build_family_context(family)
  end

  def build_family_context(family)
    sections = []

    members = family.users.map do |m|
      "- #{m.name} (#{m.role}) — #{m.available_points} pts available"
    end
    sections << "### Members\n#{members.join("\n")}"

    tasks = family.tasks.where(status: false).order(:end_date).limit(15)
    if tasks.any?
      lines = tasks.map do |t|
        "- #{t.name} — #{t.user.name} | #{t.task_points} pts | due #{t.end_date&.strftime('%b %d') || 'no date'}"
      end
      sections << "### Active tasks\n#{lines.join("\n")}"
    else
      sections << "### Active tasks\nNo pending tasks."
    end

    week_plans = family.meal_plans.includes(recipe_meal_plans: :recipe).where(day: Date.today..7.days.from_now).order(:day)
    if week_plans.any?
      lines = week_plans.flat_map do |plan|
        plan.recipe_meal_plans.map do |rmp|
          "- #{plan.day.strftime('%A %b %d')} — #{rmp.meal_type.capitalize}: #{rmp.recipe&.name || 'TBD'}"
        end
      end
      sections << "### This week's meals\n#{lines.join("\n")}"
    else
      sections << "### This week's meals\nNothing planned yet."
    end

    rewards = Reward.joins(:user).where(users: { family_id: family.id }).limit(10)
    if rewards.any?
      lines = rewards.map { |r| "- #{r.name}: #{r.reward_points} pts (#{r.user.name})" }
      sections << "### Active rewards\n#{lines.join("\n")}"
    end

    adjustments = PointAdjustment.joins(:user).where(users: { family_id: family.id }).order(created_at: :desc).limit(8)
    if adjustments.any?
      lines = adjustments.map do |a|
        sign = a.amount.to_i > 0 ? "+" : ""
        "- #{a.user.name}: #{sign}#{a.amount} pts — #{a.reason} (#{a.created_at.strftime('%b %d')})"
      end
      sections << "### Recent point history\n#{lines.join("\n")}"
    end

    saved_recipes = Recipe.all.limit(30)
    if saved_recipes.any?
      lines = saved_recipes.map { |r| "- #{r.name} (#{r.calories} kcal, allergens: #{r.allergens.presence || 'none'})" }
      sections << "### Saved recipes\n#{lines.join("\n")}"
    end

    sections.join("\n\n")
  end

  def send_question(model: "gpt-4o", with: {})
    @ruby_llm_chat = RubyLLM.chat(model: model)

    build_conversation_history

    @response = @ruby_llm_chat.with_instructions(system_prompt_with_context).ask(@message.content, with: with) do |chunk|
      next if chunk.content.blank?

      @assistant_message.content += chunk.content
      broadcast_replace(@assistant_message)
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
