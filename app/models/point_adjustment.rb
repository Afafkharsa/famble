class PointAdjustment < ApplicationRecord
  belongs_to :user
  validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :kind, inclusion: { in: %w[add deduct] }
  validates :reason, presence: true, if: -> { kind == "deduct" }
end
