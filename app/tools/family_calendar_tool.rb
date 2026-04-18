class FamilyCalendarTool < RubyLLM::Tool
  description "Returns upcoming events on the family calendar. Use this to answer questions about who is doing what, scheduling conflicts, or what's happening on a specific day."

  param :days_ahead, desc: "How many days to look forward starting today (default 14).", required: false, type: "integer"

  def initialize(family:)
    @family = family
  end

  def execute(days_ahead: 14)
    start_time = Time.current.beginning_of_day
    end_time   = start_time + days_ahead.to_i.days

    events = Event.joins(:user)
                  .where(users: { family_id: @family.id })
                  .where(start_time: start_time..end_time)
                  .order(:start_time)

    events.map do |e|
      {
        title:      e.title,
        owner:      e.user&.name || e.user&.email,
        starts_at:  e.start_time&.strftime("%Y-%m-%d %H:%M"),
        ends_at:    (e.respond_to?(:end_time) ? e.end_time : nil)&.strftime("%Y-%m-%d %H:%M")
      }
    end
  rescue => e
    { error: e.message }
  end
end
