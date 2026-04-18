class FamilyMembersTool < RubyLLM::Tool
  description "Returns every member of the current family with their role, age, and current reward points balance. Use this whenever the user asks about who's in the family, who has how many points, or anything that needs names + ages."

  def initialize(family:)
    @family = family
  end

  def execute
    @family.users.map do |u|
      age = u.birthdate ? ((Date.current - u.birthdate).to_i / 365) : nil
      {
        name:             u.name || u.email,
        role:             u.role,
        age:              age,
        points_to_spend:  u.available_points,
        points_earned:    u.earned_points
      }
    end
  rescue => e
    { error: e.message }
  end
end
