class Reward < ApplicationRecord
  belongs_to :user
  belongs_to :reward_template, optional: true
  has_one_attached :photo
  validates :name, :reward_points, presence: true
  validates :reward_points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  ICON_OPTIONS = %w[
    star book-open moon film gift ice-cream heart coffee compass
    shopping-bag trophy sparkles music palette bike pizza
  ].freeze

  ICON_BG_COLORS = %w[#E6C84A #74B8CC #E8AFAF #7FCB90].freeze

  def icon_bg_color
    ICON_BG_COLORS[id % ICON_BG_COLORS.size]
  end
end
