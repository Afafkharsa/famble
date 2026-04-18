class FamilyRewardsTool < RubyLLM::Tool
  description "Returns rewards for family members with the progress toward each (points required, points available, how many points away). Use this to answer how close someone is to a reward or which rewards are redeemable right now."

  param :user_name, desc: "Optional family member first name to filter rewards to one person.", required: false

  def initialize(family:)
    @family = family
  end

  def execute(user_name: nil)
    users = @family.users
    users = users.where("LOWER(users.name) = ?", user_name.downcase) if user_name.present?

    users.flat_map do |u|
      u.rewards.where(redeemed: false).map do |r|
        diff = r.reward_points - u.available_points
        {
          member:          u.name || u.email,
          reward:          r.name,
          description:     r.description,
          cost:            r.reward_points,
          points_available: u.available_points,
          status:          diff <= 0 ? "ready_to_redeem" : "#{diff} points away"
        }
      end
    end
  rescue => e
    { error: e.message }
  end
end
