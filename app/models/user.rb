class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :chats, dependent: :destroy
  has_many :tasks, dependent: :destroy
  belongs_to :family, optional: true
  has_one_attached :photo
  has_many :rewards, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :point_adjustments, dependent: :destroy
  has_many :given_point_adjustments, class_name: "PointAdjustment",
           foreign_key: :created_by_id, inverse_of: :created_by, dependent: :destroy
           has_many :event_participations, dependent: :destroy
  has_many :participated_events, through: :event_participations, source: :event

  validates :email, uniqueness: true

  def earned_points
    scope_after_reset(tasks.where(validation: true), "tasks.updated_at").sum(:task_points)
  end

  def spent_points
    scope_after_reset(rewards.where(redeemed: true), "rewards.redeemed_at").sum(:reward_points)
  end

  def adjusted_points
    scope_after_reset(point_adjustments, "point_adjustments.created_at").sum(:amount)
  end

  def available_points
    earned_points - spent_points + adjusted_points
  end

  def parent?
    role.to_s.downcase == "parent"
  end

  # Presentation helpers (used by the rewards page)
  AVATAR_COLORS = %w[#E6C84A #74B8CC #E8AFAF #7FCB90].freeze

  def avatar_color
    color.presence || AVATAR_COLORS[id % AVATAR_COLORS.size]
  end

  def initials
    source = name.presence || email.to_s
    letters = source.scan(/[A-Za-z]/).first(2).join
    letters.upcase.presence || "?"
  end

  def display_name
    name.presence || email.to_s.split("@").first
  end

  private

  def scope_after_reset(scope, column)
    points_reset_at ? scope.where("#{column} > ?", points_reset_at) : scope
  end
end
