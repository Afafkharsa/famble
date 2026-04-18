class PointAdjustment < ApplicationRecord
  belongs_to :user
  belongs_to :created_by, class_name: "User"

  validates :amount, presence: true, numericality: { other_than: 0 }
  validates :reason, presence: true, if: -> { amount.to_i.negative? }

  ADD_REASONS = [
    "Helped without being asked",
    "Was kind to sibling",
    "Did extra chores",
    "Showed good manners",
    "Great teamwork",
    "Shared nicely",
    "Was patient and calm"
  ].freeze

  REMOVE_REASONS = [
    "Not kind to sibling",
    "Didn't do chores",
    "Talked back to parent",
    "Screen time violation",
    "Didn't follow house rules",
    "Made a mess and didn't clean up",
    "Was dishonest"
  ].freeze

  def label
    amount.positive? ? "+#{amount} pts awarded" : "#{amount} pts deducted"
  end
end
