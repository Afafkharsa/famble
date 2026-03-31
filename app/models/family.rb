class Family < ApplicationRecord
  has_many :tasks, through: :user
end
