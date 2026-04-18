class Task < ApplicationRecord
  belongs_to :user
  belongs_to :task_template, optional: true
  has_one :family, through: :user

  validates :name, presence: true, length: { minimum: 2 }
  validates :task_points, numericality: { greater_than_or_equal_to: 1 }
  validates :end_date, comparison: { greater_than_or_equal_to: :start_date }

def status_label
  return "Done"             if validation
  return "Waiting approval" if status
  "To do"
end

def status_icon
  return "bi-check-circle-fill" if validation
  return "bi-hourglass-split"   if status
  "bi-circle"
end

STATUS_BG_COLORS = {
  done:             "#BDE3C3",
  waiting_approval: "#F8F7BA",
  to_do:            "#F5D2D2"
}.freeze

def status_bg_color
  return STATUS_BG_COLORS[:done]             if validation
  return STATUS_BG_COLORS[:waiting_approval] if status

  STATUS_BG_COLORS[:to_do]
end

end
