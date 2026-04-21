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


  validates :email, uniqueness: true

  MEMBER_COLORS = %w[#F5D2D2 #F8F7BA #A3CCDA #BDE3C3 #E8D5F5 #FFE4C4 #C4E8FF #D5F5E3].freeze
  before_create :assign_color

  def earned_points
    tasks.where(status: true).sum(:task_points) +
      point_adjustments.where(kind: "add").sum(:amount)
  end

  def spent_points
    rewards.where(redeemed: true).sum(:reward_points) +
      point_adjustments.where(kind: "deduct").sum(:amount)
  end

  def available_points
    earned_points - spent_points
  end

  def display_name
    name.presence || email
  end

  def point_history
    history = []
    tasks.where(status: true).each do |t|
      history << { amount: t.task_points, kind: "earn", reason: t.name, date: t.updated_at }
    end
    rewards.where(redeemed: true).each do |r|
      history << { amount: r.reward_points, kind: "spend", reason: r.name, date: r.redeemed_at }
    end
    point_adjustments.each do |a|
      history << { amount: a.amount, kind: a.kind, reason: a.reason.presence || "Manual adjustment", date: a.created_at }
    end
    history.sort_by { |e| e[:date] || Time.current }.reverse
  end

  private

  def assign_color
    used = family&.users&.pluck(:color) || []
    self.color ||= (MEMBER_COLORS - used).first || MEMBER_COLORS.sample
  end
end
