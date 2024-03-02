class Tour < ApplicationRecord
  enum :mode, { oneTime: 1, recurring: 2 }
  enum :status, { active: 1, ended: 2, cancelled: 3 }

  belongs_to :user

  has_many :slots
end
