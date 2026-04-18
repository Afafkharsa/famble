class FamilyTasksTool < RubyLLM::Tool
  description "Returns tasks for the family. Use this to answer what tasks are due, who has what chore, which tasks are awaiting parent validation, or to summarize progress. Supports filtering by status."

  param :status, desc: "Filter: 'open' (not yet marked done), 'waiting_approval' (done by the child, not yet validated), 'validated' (fully approved), or 'all'. Defaults to 'open'.", required: false
  param :user_name, desc: "Optional family member first name to filter tasks to one person.", required: false

  def initialize(family:)
    @family = family
  end

  def execute(status: "open", user_name: nil)
    scope = @family.tasks.includes(:user).order(:end_date)

    scope = case status.to_s.downcase
            when "waiting_approval" then scope.where(status: true, validation: [false, nil])
            when "validated"        then scope.where(validation: true)
            when "all"              then scope
            else                         scope.where(validation: [false, nil])
            end

    scope = scope.joins(:user).where("LOWER(users.name) = ?", user_name.downcase) if user_name.present?

    scope.limit(30).map do |t|
      {
        name:        t.name,
        description: t.description,
        assignee:    t.user.name || t.user.email,
        points:      t.task_points,
        due:         t.end_date&.to_s,
        status:      t.status_label
      }
    end
  rescue => e
    { error: e.message }
  end
end
